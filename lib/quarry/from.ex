defmodule Quarry.From do
  @moduledoc false
  require Ecto.Query

  alias Quarry.QueryStruct

  def build({schema, errors}, bind_prefix \\ nil) do
    raw_binding = schema |> Module.split() |> List.last() |> Macro.underscore() |> String.to_atom()

    binding =
      if is_nil(bind_prefix),
        do: raw_binding,
        else: String.to_atom("#{bind_prefix}_#{raw_binding}")

    Ecto.Query.from(p in schema)
    |> QueryStruct.with_from_as(binding)
    |> then(&{&1, errors})
  end

  def get_root_binding(query), do: query.from.as
  def get_root_schema(query), do: elem(query.from.source, 1)
end
