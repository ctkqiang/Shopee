defmodule Shopee do
  @behaviour Crawly.Spider

  @impl Crawly.Spider
  def base_url() do
    "https://shopee.com.my"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: ["https://shopee.com.my/search?keyword=computer"]
    ]
  end

  @impl Crawly.Spider
  def parse_item(_response) do
    %Crawly.ParsedItem{:items => [], :requests => []}
  end

  def show() do
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
