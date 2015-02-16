module GooglePlaces
  class Rectangle
    def initialize(lat1, lng1, lat2, lng2)
      @lat1 = ("%.8f"%lat1)
      @lng1 = ("%.8f"%lng1)
      @lat2 = ("%.8f"%lat2)
      @lng2 = ("%.8f"%lng2)
    end

    def format
      #SW point of rectangle
      a1 = [@lat1, @lat2].join (',')
      #NE point of rectangle
      a2 = [@lat2, @lng2].join(',')
      #Bounds must be separated by a '|'
      [a1, a2].join('|')
    end
  end
end
