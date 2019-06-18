module GooglePlaces
  # This class performs the queries on the API
  class Request
    # @return [HTTParty::Response] the retrieved response from the API
    attr_accessor :response
    attr_reader :options

    include ::HTTParty
    format :json

    NEARBY_SEARCH_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
    DETAILS_URL       = 'https://maps.googleapis.com/maps/api/place/details/json'
    PHOTO_URL         = 'https://maps.googleapis.com/maps/api/place/photo'
    TEXT_SEARCH_URL   = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
    PAGETOKEN_URL     = 'https://maps.googleapis.com/maps/api/place/search/json'
    RADAR_SEARCH_URL  = 'https://maps.googleapis.com/maps/api/place/radarsearch/json'
    AUTOCOMPLETE_URL  = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'

    # Search for Spots at the provided location
    #
    # @return [Array<Spot>]
    # @param [Hash] options
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [Integer] :radius
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if <b>:rankby</b> is specified
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [(Integer,Integer),String] :location
    #   The latitude/longitude around which to retrieve Spot information. This must be specified as latitude,longitude
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
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots(options = {})
      request = new(NEARBY_SEARCH_URL, options)
      request.parsed_response
    end

    # Search for a Spot with a place_id key
    #
    # @return [Spot]
    # @param [Hash] options
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :place_id
    #   The place_id of the Spot. This parameter should be sent as placeid
    #   in requests but is snake_cased in responses (place_id)
    #   @see: https://developers.google.com/places/documentation/details
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String] :region
    #   The region code, specified as a ccTLD (country code top-level domain) two-character value. Most ccTLD
    #   codes are identical to ISO 3166-1 codes, with some exceptions. This parameter will only influence, not
    #   fully restrict, search results. If more relevant results exist outside of the specified region, they may
    #   be included. When this parameter is used, the country name is omitted from the resulting formatted_address
    #   for results in the specified region.
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    def self.spot(options = {})
      request = new(DETAILS_URL, options)
      request.parsed_response
    end

    # @param [Hash] options
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :location
    #   the lat, lng for the search
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
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @see https://developers.google.com/places/documentation/search#RadarSearchRequests Radar Search
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots_by_radar(options = {})
      request = new(RADAR_SEARCH_URL, options)
      request.parsed_response
    end

    # Search for Spots within a give SW|NE bounds with query
    #
    # @return [Array<Spot>]
    # @param [Hash] bounds
    # @param [String] api_key the provided api key
    # @param [Hash] options
    # @option bounds [String, Integer] :se
    #   the southeast lat|lng pair
    # @option bounds [:se][String, Integer] :lat
    #   the SE latitude
    # @option bounds [:se][String, Integer] :lng
    #   the SE longitude
    # @option bounds [:se][String, Integer] :lat
    #   the SE latitude
    # @option bounds [:se][String, Integer] :lng
    #   the SE longitude
    # @option options [String,Array] :query
    #   Restricts the results to Spots matching term(s) in the specified query
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
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots_by_bounds(options = {})
      request = new(TEXT_SEARCH_URL, options)
      request.parsed_response
    end
    # Search for Spots with a query
    #
    # @return [Array<Spot>]
    # @param [String] query the query to search for
    # @param [String] api_key the provided api key
    # @param [Hash] options
    # @option options [String,Integer] :lat
    #   the latitude for the search
    # @option options [String,Integer] :lng
    #   the longitude for the search
    # @option options [Integer] :radius
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if <b>:rankby</b> is specified
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [String] :region
    #   The region code, specified as a ccTLD (country code top-level domain) two-character value. Most ccTLD
    #   codes are identical to ISO 3166-1 codes, with some exceptions. This parameter will only influence, not
    #   fully restrict, search results. If more relevant results exist outside of the specified region, they may
    #   be included. When this parameter is used, the country name is omitted from the resulting formatted_address
    #   for results in the specified region.
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots_by_query(options = {})
      request = new(TEXT_SEARCH_URL, options)
      request.parsed_response
    end

    # Search for Spots with a page token
    #
    # @return [Array<Spot>]
    # @param [String] pagetoken the next page token to search for
    # @param [String] api_key the provided api key
    # @param [Hash] options
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots_by_pagetoken(options = {})
      request = new(PAGETOKEN_URL, options)
      request.parsed_response
    end

    # Query for Place Predictions
    #
    # @return [Array<Prediction>]
    # @param [String] api_key the provided api key
    # @param [Hash] options
    # @option options [String,Array<String>] :exclude ([])
    #   A String or an Array of <b>types</b> to exclude from results
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.predictions_by_input(options = {})
      request = new(AUTOCOMPLETE_URL, options)
      request.parsed_response
    end

    # Search for a Photo's URL with a reference key
    #
    # @return [URL]
    # @param [Hash] options
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [Integer] :maxwidth
    #   The maximum width of the photo url to be returned
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :photoreference
    #   The reference of a already retrieved Photo
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    def self.photo_url(options = {})
      request = new(PHOTO_URL, options, false)
      request.parsed_response
    end

    # Create a new Request for a given uri and the provided params
    #
    # @return [Request]
    # @param [String] url The uri to make the query on
    # @param [Hash] options A Hash providing options for the request
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [Integer] :radius
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if <b>:rankby</b> is specified
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [(Integer,Integer),String] :location
    #   The latitude/longitude around which to retrieve Spot information. This must be specified as latitude,longitude
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
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def initialize(url, options, follow_redirects = true)
      retry_options = options.delete(:retry_options) || {}

      retry_options[:status] ||= []
      retry_options[:max]    ||= 0
      retry_options[:delay]  ||= 5
      retry_options[:status] = [retry_options[:status]] unless retry_options[:status].is_a?(Array)
      @response = self.class.get(url, :query => options, :follow_redirects => follow_redirects)

      return unless retry_options[:max] > 0 && retry_options[:status].include?(@response.parsed_response['status'])

      retry_request = proc do
        for i in (1..retry_options[:max])
          sleep(retry_options[:delay])

          @response = self.class.get(url, :query => options, :follow_redirects => follow_redirects)

          break unless retry_options[:status].include?(@response.parsed_response['status'])
        end
      end

      if retry_options[:timeout]
        begin
          Timeout::timeout(retry_options[:timeout]) do
            retry_request.call
          end
        rescue Timeout::Error
          raise RetryTimeoutError.new(@response)
        end
      else
        retry_request.call

        raise RetryError.new(@response) if retry_options[:status].include?(@response.parsed_response['status'])
      end
    end

    def execute
      @response = self.class.get(url, :query => options, :follow_redirects => follow_redirects)
    end

    # Parse errors from the server respons, if any
    # @raise [OverQueryLimitError] when server response object includes status 'OVER_QUERY_LIMIT'
    # @raise [RequestDeniedError] when server response object includes 'REQUEST_DENIED'
    # @raise [InvalidRequestError] when server response object includes 'INVALID_REQUEST'
    # @raise [UnknownError] when server response object includes 'UNKNOWN_ERROR'
    # @raise [NotFoundError] when server response object includes 'NOT_FOUND'
    # @return [String] the response from the server as JSON
    def parsed_response
      return @response.headers["location"] if @response.code >= 300 && @response.code < 400
      raise APIConnectionError.new(@response) if @response.code >= 500 && @response.code < 600
      case @response.parsed_response['status']
      when 'OK', 'ZERO_RESULTS'
        @response.parsed_response
      when 'OVER_QUERY_LIMIT'
        raise OverQueryLimitError.new(@response)
      when 'REQUEST_DENIED'
        raise RequestDeniedError.new(@response)
      when 'INVALID_REQUEST'
        raise InvalidRequestError.new(@response)
      when 'UNKNOWN_ERROR'
        raise UnknownError.new(@response)
      when 'NOT_FOUND'
        raise NotFoundError.new(@response)
      end
    end
  end
end
