defmodule UspsEx.Config do
  @moduledoc false

  alias UspsEx.InvalidConfigError

  def config() do
    with un when is_binary(un) <-
           Application.get_env(:ups_ex, :username, {:error, :not_found, :username}),
         pw when is_binary(pw) <-
           Application.get_env(:ups_ex, :password, {:error, :not_found, :password}) do
      %{
        username: un,
        password: pw
      }
    else
      {:error, :not_found, token} ->
        raise InvalidConfigError, message: "USPS config key missing: #{token}"

      {:error, :not_found} ->
        raise InvalidConfigError, message: "USPS config is either invalid or not found."
    end
  end

  def currency_code() do
    case Application.get_env(:ups_ex, :currency, :usd) do
      code when code in [:usd, :can, :mxn] ->
        code |> Atom.to_string() |> String.upcase()

      _ ->
        raise InvalidConfigError, "UspsEx currency must be either :usd, :can, or :mxn"
    end
  end

  def env() do
    case Application.get_env(:ups_ex, :env, :dev) do
      e when e in [:dev, :prod] -> e
      _ -> raise InvalidConfigError, "UspsEx env must be either :dev or :prod"
    end
  end
end