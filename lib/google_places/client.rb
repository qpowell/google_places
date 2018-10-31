module GooglePlaces
  # This class acts as a proxy to the working classes when requesting data from the API.
  class Client
    # @return [String] the provided api key
    attr_reader :api_key
    # @return [Hash] the provided options hash
    attr_reader :options

    # Creates a new Client instance which proxies the requests to the certain classes
    #
    # @param [String] api_key The api key to use for the requests
    # @param [Hash] options An options hash for requests. Is used as the query parameters on server requests
    # @option options [String,Integer] lat
    #   the latitude for the search
    # @option options [String,Integer] lng
    #   the longitude for the search
    # @option options [Integer] :radius
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if <b>:rankby</b> is specified
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :name
    #   A term to be matched against the names of Places.
    #   Results will be restricted to those containing the passed name value.
    # @option options [String] :keyword
    #   A term to be matched against all content that Google has indexed for this Spot,
    #   including but not limited to name, type, and address,
    #   as well as customer reviews and other third-party content.
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String,Array<String>] :exclude
    #   A String or an Array of <b>types</b> to exclude from results
    #
    # @option options [Hash] :retry_options
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status]
    # @option options [Integer] :retry_options[:max] the maximum retries
    # @option options [Integer] :retry_options[:delay] the delay between each retry in seconds
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types

    def initialize(api_key = @api_key, options = {})
      api_key ? @api_key = api_key : @api_key = GooglePlaces.api_key
      @options = options
    end

    # Search for Spots at the provided location
    #
    # @return [Array<Spot>]
    # @param [String,Integer] lat the latitude for the search
    # @param [String,Integer] lng the longitude for the search
    # @param [Hash] options
    # @option options [Integer] :radius (1000)
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if :rankby => 'distance' (described below) is specified.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :rankby
    #   Specifies the order in which results are listed. Possible values are:
    #   - prominence (default). This option sorts results based on their importance.
    #     Ranking will favor prominent places within the specified area.
    #     Prominence can be affected by a Place's ranking in Google's index,
    #     the number of check-ins from your application, global popularity, and other factors.
    #   - distance. This option sorts results in ascending order by their distance from the specified location.
    #     Ranking results by distance will set a fixed search radius of 50km.
    #     One or more of keyword, name, or types is required.
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :name
    #   A term to be matched against the names of Places.
    #   Results will be restricted to those containing the passed name value.
    # @option options [String] :keyword
    #   A term to be matched against all content that Google has indexed for this Spot,
    #   including but not limited to name, type, and address,
    #   as well as customer reviews and other third-party content.
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @option options [Boolean] :detail
    #   A boolean to return spots with full detail information(its complete address, phone number, user rating, reviews, etc)
    #   Note) This makes an extra call for each spot for more information.
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def spots(lat, lng, options = {})
      options = @options.merge(options)
      detail = options.delete(:detail)
      collection_detail_level(
        Spot.list(lat, lng, @api_key, options),
        detail
      )
    end

    # Search for a Spot with a reference key
    #
    # @return [Spot]
    # @param [String] place_id the place_id of the spot
    # @param [Hash] options
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    def spot(place_id, options = {})
      Spot.find(place_id, @api_key, @options.merge(options))
    end

    # Search for Spots with a query
    #
    # @return [Array<Spot>]
    # @param [String] query the query to search for
    # @param [Hash] options
    # @option options [String,Integer] lat the latitude for the search
    # @option options [String,Integer] lng the longitude for the search
    # @option options [Integer] :radius (1000)
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if :rankby => 'distance' (described below) is specified.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :rankby
    #   Specifies the order in which results are listed. Possible values are:
    #   - prominence (default). This option sorts results based on their importance.
    #     Ranking will favor prominent places within the specified area.
    #     Prominence can be affected by a Place's ranking in Google's index,
    #     the number of check-ins from your application, global popularity, and other factors.
    #   - distance. This option sorts results in ascending order by their distance from the specified location.
    #     Ranking results by distance will set a fixed search radius of 50km.
    #     One or more of keyword, name, or types is required.                                                                                                                                                                                                                                                                                       distance. This option sorts results in ascending order by their distance from the specified location. Ranking results by distance will set a fixed search radius of 50km. One or more of keyword, name, or types is required.
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    # @option options [Boolean] :detail
    #   A boolean to return spots with full detail information(its complete address, phone number, user rating, reviews, etc)
    #   Note) This makes an extra call for each spot for more information.
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def spots_by_query(query, options = {})
      options = @options.merge(options)
      detail = options.delete(:detail)
      collection_detail_level(
        Spot.list_by_query(query, @api_key, options),
        detail
      )
    end
    # Search for Spots within a give SW|NE bounds with query
    #
    # @return [Array<Spot>]
    # @param [Hash] bounds
    # @param [String] api_key the provided api key
    # @param [Hash] options
    # @option bounds [String, Array] :start_point
    #   An array that contains the lat/lng pair for the first
    #     point in the bounds (rectangle)
    # @option bounds [:start_point][String, Integer] :lat
    #   The starting point coordinates latitude value
    # @option bounds [:start_point][String, Integer] :lng
    #   The starting point coordinates longitude value
    # @option bounds [String, Array] :end_point
    #   An array that contains the lat/lng pair for the end
    #     point in the bounds (rectangle)
    # @option bounds [:end_point][String, Integer] :lat
    #   The end point coordinates latitude value
    # @option bounds [:end_point][String, Integer] :lng
    #   The end point coordinates longitude value
    # @option options [String,Array] :query
    #   Restricts the results to Spots matching term(s) in the specified query
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    # @option options [Boolean] :detail
    #   A boolean to return spots with full detail information(its complete address, phone number, user rating, reviews, etc)
    #   Note) This makes an extra call for each spot for more information.
    #
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def spots_by_bounds(bounds, options = {})
      options = @options.merge(options)
      detail = options.delete(:detail)
      collection_detail_level(
        Spot.list_by_bounds(bounds, @api_key, options),
        detail
      )
    end
    # Search for Spots with a pagetoken
    #
    # @return [Array<Spot>]
    # @param [String] pagetoken the next page token to search for
    # @param [Hash] options
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    # @option options [Boolean] :detail
    #   A boolean to return spots with full detail information(its complete address, phone number, user rating, reviews, etc)
    #   Note) This makes an extra call for each spot for more information.
    #
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def spots_by_pagetoken(pagetoken, options = {})
      options = @options.merge(options)
      detail = options.delete(:detail)
      collection_detail_level(
        Spot.list_by_pagetoken(pagetoken, @api_key, options),
        detail
      )
    end

    #
    # @return [Array<Spot>]
    # @param [String,Integer] lat the latitude for the search
    # @param [String,Integer] lng the longitude for the search
    # @param [Hash] options
    # @option options [Integer] :radius (1000)
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :name
    #   A term to be matched against the names of Places.
    #   Results will be restricted to those containing the passed name value.
    # @option options [String] :keyword
    #   A term to be matched against all content that Google has indexed for this Spot,
    #   including but not limited to name, type, and address,
    #   as well as customer reviews and other third-party content.
    # @option options [Integer] :minprice
    #   Restricts results to only those places within the specified price range. Valid values range between 0 (most affordable) to 4 (most expensive), inclusive.
    # @option options [Integer] :maxprice
    #   Restricts results to only those places within the specified price range. Valid values range between 0 (most affordable) to 4 (most expensive), inclusive.
    # @option options [Boolean] :opennow
    #   Retricts results to those Places that are open for business at the time the query is sent.
    #   Places that do not specify opening hours in the Google Places database will not be returned if you include this parameter in your query.
    #   Setting openNow to false has no effect.
    # @option options [Boolean] :zagatselected
    #   Restrict your search to only those locations that are Zagat selected businesses.
    #   This parameter does not require a true or false value, simply including the parameter in the request is sufficient to restrict your search.
    #   The zagatselected parameter is experimental, and only available to Places API enterprise customers.
    # @option options [Boolean] :detail
    #   A boolean to return spots with full detail information(its complete address, phone number, user rating, reviews, etc)
    #   Note) This makes an extra call for each spot for more information.
    #

    # Query for Place Predictions
    #
    # @return [Array<Prediction>]
    # @param [String] query the query to search for
    # @param [Hash] options
    # @option options [String,Integer] lat the latitude for the search
    # @option options [String,Integer] lng the longitude for the search
    # @option options [Integer] :radius (1000)
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if :rankby => 'distance' (described below) is specified.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def predictions_by_input(input, options = {})
      Prediction.list_by_input(input, @api_key, @options.merge(options))
    end

    private

    def collection_detail_level(spots, detail = false)
      if detail
        spots.map do |spot|
          Spot.find(spot.place_id, @api_key, @options)
        end
      else
        spots
      end
    end
  end
end
