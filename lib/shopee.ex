defmodule Shopee do
  @behaviour Crawly.Spider

  @doc """
  Execute by
  Crawly.Engine.start_spider({defmodule_name})
  eg.
    ``` Crawly.Engine.start_spider(Shopee)```
  """

  @impl Crawly.Spider
  def base_url() do
    "https://shopee.com.my"
  end

  @impl Crawly.Spider
  def init(_) do
    [start_urls: ["https://shopee.com.my/api/v2/search_items/?by=relevancy&keyword=computer&limit=10&newest=0&order=desc&page_type=search"]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    urls =
      response.body
      |> Floki.find("a._1YAByT")
      |> Floki.attribute("href")

    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url(response.request_url)
        |> Crawly.Utils.request_from_url()
      end)

    name =
      response.body
      |> Floki.find("._1POlWt")
      |> Floki.text()

    price =
      response.body
      |> Floki.find("._5W0f35")
      |> Floki.text(deep: false, sep: "")

    IO.puts "#{response.body} \n" |> to_string()

    %Crawly.ParsedItem {
      :requests => requests,
      :items => [
        %{name: name, price: price}
      ]
    }
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url) |> to_string()
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
