defmodule EbanxFinancialService.ConCacheRepo do
  @moduledoc false

  @spec get_by_id(String.t(), integer()) :: {:not_found, String.t()} | {:ok, map()}
  def get_by_id(table, id) do
    case ConCache.get(repo_name(), set_lookup_key(table, id)) do
      nil -> {:not_found, "resource with id #{id} not found in table #{table}"}
      row -> {:ok, row}
    end
  end

  @spec create(String.t(), map()) :: {:ok, map} | {:error, :already_exists}
  def create(table, data) do
    case ConCache.insert_new(
           repo_name(),
           set_lookup_key(
             table,
             data["id"]
           ),
           cast_row(data)
         ) do
      {:error, _} = error -> error
      :ok -> {:ok, data}
    end
  end

  @spec update_with_row_lock(String.t(), integer(), map()) :: :ok | {:error, any}
  def update_with_row_lock(table, id, data) do
    ConCache.update_existing(repo_name(), set_lookup_key(table, id), fn old_value ->
      {:ok, Map.merge(old_value, data)}
    end)
  end

  defp set_lookup_key(table, id), do: "#{table}/#{id}"

  defp cast_row(%{"id" => id} = row) when is_binary(id), do: row

  defp cast_row(%{"id" => id} = row) when is_integer(id),
    do: %{row | "id" => Integer.to_string(id)}

  defp repo_name do
    :ebanx_financial_service
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:repo_name)
  end
end
