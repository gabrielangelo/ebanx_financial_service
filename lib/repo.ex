defmodule EbanxFinancialService.ConCache.Repo do
  @repo_name :ebanx_financial_service
             |> Application.fetch_env!(__MODULE__)
             |> Keyword.get(:repo_name)

  def get_by_id(table, id), do: ConCache.get(@repo_name, set_lookup_key(table, id))

  def create(table, data) do
    case ConCache.insert_new(@repo_name, set_lookup_key(table, data["id"]), data) do
      {:error, _} = error -> error
      _ -> data
    end
  end

  def update_with_row_lock(table, id, data) do
    ConCache.update(@repo_name, set_lookup_key(table, id), fn old_value ->
      # This function is isolated on a row level. Modifications such as update, put, delete,
      # on this key will wait for this function to finish.
      # Modifications on other items are not affected.
      # Reads are always dirty.

      {:ok, Map.merge(old_value, data)}
    end)
  end

  defp set_lookup_key(table, id), do: "#{table}/#{id}"
end
