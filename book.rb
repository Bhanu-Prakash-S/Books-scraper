class Book
    attr_reader :position, :title, :rating, :price, :img, :availability

    def initialize(position:, title:, rating:, price:, img:, availability:)
                @position = position
                @title = title
            @rating = rating
            @price = price
            @img = img
            @availability = availability
    end

    def to_h
            {
                position: @position,
              title: @title,
              rating: @rating,
              price: @price,
              img: @img,
              availability: @availability
    }.compact
    end
end