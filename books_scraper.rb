require "faraday"
require "json"
require "nokogiri"
require_relative "book"
require_relative "categories_scraper"

def to_ratings(rating)
    case rating
    when "Three" 
        return "3/5"
    when "Four"
        return "4/5"
    when "Five"
        return "5/5"
    when "Two"
        return "2/5"
    when "One"
        return "1/5"
    end  
end

def get_clean_link(img_link)
    base_img_link = "https://books.toscrape.com/"
    img_link = img_link.delete_prefix("../../../../")
    
    return URI.join(base_img_link, img_link).to_s
end

def scrape(category = "books")

    current_cat = get_categories[category]
    
    base_url = 'https://books.toscrape.com/catalogue/'
    next_page = category == "books" ? 'page-1.html' : current_cat + 'index.html'
    clean_books = []
    position = 0
    while next_page != nil
        
        response = Faraday.get(base_url + next_page)
        doc = Nokogiri::HTML(response.body)
        
        books = doc.css("article.product_pod")
        books.each do |book|
            
            title = book.at_css("img")["alt"] 
            img =  book.at_css("img")["src"] 
            price = book.at_css("p.price_color").text 
            rating = book.at_css("p.star-rating")["class"].split.last 
            availability = book.at_css("p.instock.availability").text.strip
            
            new_book = Book.new(position: position = position + 1, title: title, rating: to_ratings(rating), price: price, img: get_clean_link(img), availability: availability)
            clean_books.push(new_book)
        end
        
        next_link =  doc.at_css("li.next a")
        next_page = next_link ? next_link["href"] : nil

        if next_page && category != "books"
            next_page = current_cat + next_page 
        end
        
    end
    puts JSON.pretty_generate(clean_books.map(&:to_h))
    
end



scrape("Travel")
