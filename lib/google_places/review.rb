module GooglePlaces
  class Review
    attr_accessor :rating, :type, :author_name, :author_url, :text, :time, :profile_photo_url

    def initialize(rating, type, author_name, author_url, text, time, profile_photo_url)
      @rating            = rating
      @type              = type
      @author_name       = author_name
      @author_url        = author_url
      @text              = text
      @time              = time
      @profile_photo_url = profile_photo_url
    end
  end
end
