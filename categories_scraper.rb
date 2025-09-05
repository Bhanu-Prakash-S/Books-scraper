require "faraday"
require "json"
require "nokogiri"


def get_categories
    
    base_url = 'https://books.toscrape.com/catalogue/category/'
    current_page = 'books_1/index.html'
    
    response = Faraday.get(base_url + current_page)
    doc = Nokogiri::HTML(response.body)

    categories = doc.css("ul.nav ul li a")
    clean_categories = {}

    categories.each do |category|
        title = category.text.strip
        link = category["href"].delete_prefix("../").delete_suffix("index.html")

        clean_categories[title] = "category/" + link
      end

    return clean_categories
end

# cats = get_categories

# puts JSON.pretty_generate(cats)