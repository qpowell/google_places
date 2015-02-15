module GooglePlaces
  class Rectangle
    def initialize(lat1, lng1, lat2, lng2)
      @lat1 = ("%.8f"%lat1)
      @lng1 = ("%.8f"%lng1)
      @lat2 = ("%.8f"%lat2)
      @lng2 = ("%.8f"%lng2)
    end

    def format
      a1 = [@lat1, @lat2].join (',')
      a2 = [@lat2, @lng2].join(',')
      [a1, a2].join('|')
    end
  end
end
