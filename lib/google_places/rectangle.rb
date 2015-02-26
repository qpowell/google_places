module GooglePlaces
  class Rectangle
    #The start_lat/lng pair values indicate the starting point of the rectangle
    #The end_lat/lng pair values indicate the end point of the rectangle
    def initialize(start_lat, start_lng, end_lat, end_lng)
      @start_point, @end_point = [ ("%.8f"%start_lat), ("%.8f"%start_lng)], [("%.8f"%end_lat), ("%.8f"%end_lng) ]
    end

    def format
      [ @start_point.join(','), @end_point.join(',') ].join('|')
    end
  end
end
