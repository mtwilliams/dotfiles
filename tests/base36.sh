#!/bin/bash

BIN=$(echo "$(dirname "$(dirname "$(realpath $0)")")/bin")

test() {
  local test="$1"
  local command="$2"
  local expected="$3"

  # Run the command and capture output.
  output=$(eval $command)

  # Compare output with expected.
  if [[ "$output" == "$expected" ]]; then
    echo "[PASS] $test"
  else
    echo "[FAIL] $test"
    echo "  Command:  $command"
    echo "  Expected: $expected"
    echo "  Got:      $output"
  fi
}

test "Encode binary 0x00 to base36" "printf '\x00' | \"$BIN/base36\" -e" "0"
test "Decode base36 0 to binary" "echo -n '0' | \"$BIN/base36\" -d | xxd -p" "00"
test "Encode 0xdeadbeef to base36" "printf '\xde\xad\xbe\xef' | \"$BIN/base36\" -e" "1PS9WXB"
test "Decode base36 1PS9WXB to binary" "echo -n '1PS9WXB' | \"$BIN/base36\" -d | xxd -p" "deadbeef"
test "Encode hex deadbeef to base36" "echo 'deadbeef' | \"$BIN/base36\" -e -x" "1PS9WXB"
test "Decode base36 1PS9WXB to hex" "echo '1PS9WXB' | \"$BIN/base36\" -d -x" "deadbeef"
test "Newline suppression in encode" "printf '\xde\xad\xbe\xef' | \"$BIN/base36\" -e -n" "1PS9WXB"
test "Handle large input" "head -c 1024 /dev/urandom | \"$BIN/base36\" -e | \"$BIN/base36\" -d | wc -c | tr -d ' '" "1024"
