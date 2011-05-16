module GooglePlaces
  class Location
    def initialize(lat, lng)
      @lat = lat
      @lng = lng
    end

    def format
      [ @lat, @lng ].join(',')
    end
  end
end
