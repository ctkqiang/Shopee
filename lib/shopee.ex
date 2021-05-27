defmodule Shopee do
  def show do
    case HTTPoison.get("https://shopee.com.my/search?keyword=computer") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
          body
          |> Floki.find(".a._35LNwy")
          |> Floki.attribute("href")

          IO.puts urls |> to_string()

          {:ok, urls}

    end
  end
end
