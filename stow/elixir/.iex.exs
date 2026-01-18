IEx.configure(
  # Unlimited history.
  history_size: -1,

  # Color the result of the last evaluation.
  colors: [eval_result: [:cyan, :bright]],

  # Pretty print the result of the last evaluation.
  inspect: [pretty: true, limit: :infinity, width: 80]
)

defmodule Helpers do
  def copy(value) when is_binary(value) do
    text =
      if is_binary(value) do
        value
      else
        inspect(value, pretty: true, limit: :infinity, width: 80)
      end

    port = Port.open({:spawn, "pbcopy"}, [:binary])
    Port.command(port, value)
    Port.close(port)

    :ok
  end

  def paste do
    port = Port.open({:spawn, "pbpaste"}, [:binary])

    receive do
      {^port, {:data, data}} ->
        true = Port.close(port)
        data

      _ ->
        true = Port.close(port)
        nil
    end
  end
end

import Helpers
