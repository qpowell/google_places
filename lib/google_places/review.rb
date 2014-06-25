module GooglePlaces
  class Review
    attr_accessor :rating, :type, :author_name, :author_url, :text, :time

    def initialize(rating, type, author_name, author_url, text, time)
      @rating       = rating
      @type         = type
      @author_name  = author_name
      @author_url   = author_url
      @text         = text
      @time         = time
    end
  end
end
