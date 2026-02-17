#!/bin/bash

input=$(cat)

: "${STATUSLINE_WARN_PCT:=60}"
: "${STATUSLINE_CRIT_PCT:=80}"
: "${STATUSLINE_CACHE_TTL:=30}"

# Render text with ANSI escape codes to style the text.
ansi() {
  local codes=""
  IFS=';' read -ra parts <<< "$1"
  for part in "${parts[@]}"; do
    case $part in
      bold) codes+="1;";;    dim) codes+="90;";;
      red)  codes+="31;";;   green)  codes+="32;";;
      yellow) codes+="33;";; cyan)   codes+="36;";;
      *) codes+="${part};";;
    esac
  done
  shift
  printf '%s' "\033[${codes%;}m${*}\033[0m"
}

# Render an OSC 8 hyperlink.
osc8() {
  printf '%s' "\e]8;;${1}\a${*:2}\e]8;;\a"
}

# Render an ASCII bar in 10% increments.
progress() {
  local pct=$1 width=${2:-10}
  local filled=$((pct * width / 100))
  local empty=$((width - filled))
  local bar=""
  [ "$filled" -gt 0 ] && bar=$(printf "%${filled}s" | tr ' ' '█')
  [ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | tr ' ' '░')"
  printf '%s' "$bar"
}

# Format a number in a human readable format.
human() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    awk "BEGIN{printf \"%.1fM\", $n/1000000}"
  elif [ "$n" -ge 1000 ]; then
    awk "BEGIN{printf \"%.1fk\", $n/1000}"
  else
    echo "$n"
  fi
}

# Check if a cache key is stale or missing.
stale() {
  local file="/tmp/claude-code-statusline-${1}"
  [ ! -f "$file" ] && return 0
  local modified
  modified=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null || echo 0)
  [ $(($(date +%s) - modified)) -gt "$STATUSLINE_CACHE_TTL" ]
}

# Read or write a cache entry.
cache() {
  local file="/tmp/claude-code-statusline-${1}"
  if [ $# -ge 2 ]; then
    printf '%s' "${*:2}" > "$file"
  else
    [ -f "$file" ] && cat "$file"
  fi
}

# Get the current branch name or short SHA.
git_branch() {
  local branch
  branch=$(git -C "$1" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$1" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  printf '%s' "$branch"
}

# Get the GitHub HTTPS URL for the origin (stripped of .git).
git_remote_url() {
  git -C "$1" --no-optional-locks remote get-url origin 2>/dev/null \
    | sed 's|git@github\.com:|https://github.com/|' \
    | sed 's|\.git$||'
}

# Render the compressed Git status: +staged ~modified -deleted ?untracked.
git_status() {
  local porcelain
  porcelain=$(git -C "$1" --no-optional-locks status --porcelain 2>/dev/null)
  [ -z "$porcelain" ] && return

  local staged modified deleted untracked status=""
  staged=$(echo "$porcelain" | grep -c '^[MADRC]' || true)
  modified=$(echo "$porcelain" | grep -c '^.M' || true)
  deleted=$(echo "$porcelain" | grep -c '^.D' || true)
  untracked=$(echo "$porcelain" | grep -c '^??' || true)

  [ "$staged" -gt 0 ] && status+="$(ansi green "+${staged}") "
  [ "$modified" -gt 0 ] && status+="$(ansi yellow "~${modified}") "
  [ "$deleted" -gt 0 ] && status+="$(ansi red "-${deleted}") "
  [ "$untracked" -gt 0 ] && status+="$(ansi dim "?${untracked}")"
  printf '%s' "[${status% }]"
}

# Render cached pull request information, refreshing in background when stale.
git_pr() {
  local key="pr-$(echo -n "$1" | md5 -q 2>/dev/null || echo -n "$1" | md5sum | cut -d' ' -f1)"

  # Read from the cache to avoid blocking.
  local pr_json pr_num pr_title pr_url
  pr_json=$(cache "$key")
  if [ -n "$pr_json" ]; then
    pr_num=$(echo "$pr_json" | jq -r '.number // empty' 2>/dev/null)
    pr_title=$(echo "$pr_json" | jq -r '.title // empty' 2>/dev/null)
    pr_url=$(echo "$pr_json" | jq -r '.url // empty' 2>/dev/null)
    [ -n "$pr_num" ] && printf '%s' "$(osc8 "$pr_url" "$(ansi cyan "PR#${pr_num}")"): ${pr_title}"
  fi

  # Refresh the cache in the background if stale.
  if stale "$key" && command -v gh > /dev/null 2>&1; then
    (cd "$1" && cache "$key" "$(gh pr view --json number,title,url 2>/dev/null)") &
  fi
}

MODEL=$(echo "$input" | jq -r '.model.display_name')
PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir')
WORKSPACE=${PROJECT_DIR##*/}
CONTEXT_WINDOW_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
PCT=$(echo "$input" | jq -r '(.context_window.used_percentage // 0) | floor')

# Extract current usage token counts.
CURRENT_INPUT=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
CURRENT_CACHE_CREATE=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
CURRENT_CACHE_READ=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
CURRENT_OUTPUT=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
CURRENT_TOTAL=$((CURRENT_INPUT + CURRENT_CACHE_CREATE + CURRENT_CACHE_READ + CURRENT_OUTPUT))

# Format the tokens used and the context window size.
TOKENS_USED_HUMAN=$(human "$CURRENT_TOTAL")
TOKENS_MAX_HUMAN=$(human "$CONTEXT_WINDOW_SIZE")

# Determine the color of the context bar based on the percentage of tokens used.
if [ "$PCT" -ge "$STATUSLINE_CRIT_PCT" ]; then BAR_STYLE="red"
elif [ "$PCT" -ge "$STATUSLINE_WARN_PCT" ]; then BAR_STYLE="yellow"
else BAR_STYLE="green"; fi

CTX="$(ansi "$BAR_STYLE" "${PCT}% [$(progress "$PCT")]") $(ansi dim "(${TOKENS_USED_HUMAN}/${TOKENS_MAX_HUMAN})")"

GIT_PART=""
PR_PART=""

# Check if the project is a Git repository.
if git -C "$PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  # Get the current branch name and the remote.
  BRANCH=$(git_branch "$PROJECT_DIR")
  REMOTE=$(git_remote_url "$PROJECT_DIR")

  if [ -n "$REMOTE" ]; then
    # Render the branch name as a hyperlink to the remote.
    GIT_PART=$(osc8 "${REMOTE}/tree/${BRANCH}" "$(ansi green "$BRANCH")")
  else
    # Render the branch name as a plain text.
    GIT_PART=$(ansi green "$BRANCH")
  fi

  # Render the Git status.
  STATUS=$(git_status "$PROJECT_DIR")
  [ -n "$STATUS" ] && GIT_PART+=" ${STATUS}"

  # Render information about the pull request.
  PR_PART=$(git_pr "$PROJECT_DIR")
fi

# Render the separator between the parts of the statusline.
SEP=$(ansi dim " | ")

# Render the output.
OUTPUT="$(ansi "bold;cyan" "$MODEL")${SEP}${WORKSPACE}${SEP}${CTX}"
[ -n "$GIT_PART" ] && OUTPUT+="${SEP}${GIT_PART}"
[ -n "$PR_PART" ] && OUTPUT+="${SEP}${PR_PART}"

printf '%b\n' "$OUTPUT"
