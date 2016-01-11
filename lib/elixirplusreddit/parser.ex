defmodule ElixirPlusReddit.Parser do

  @moduledoc """
  A parser built with Poison for decoding Reddit's various return
  structures.
  """

  def parse(%HTTPotion.Response{body: body, status_code: code}, strategy) do
    case code do
      _ ->
        body = Poison.decode!(body, keys: :atoms)
        parse(body, strategy)
    end
  end

  def parse(resp, :token) do
    "bearer #{resp.access_token}"
  end

  def parse(resp, _) do
    resp
  end

end
