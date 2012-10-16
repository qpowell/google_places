module GooglePlaces
  class Location
    def initialize(lat, lng)
      @lat = ("%.8f"%lat)
      @lng = ("%.8f"%lng)
    end

    def format
      [ @lat, @lng ].join(',')
    end
  end
end
