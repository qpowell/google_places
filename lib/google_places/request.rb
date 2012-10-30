module GooglePlaces
  # This class performs the queries on the API
  class Request
    # @return [HTTParty::Response] the retrieved response from the API
    attr_accessor :response
    attr_reader :options

    include ::HTTParty
    format :json

    SPOTS_LIST_URL = 'https://maps.googleapis.com/maps/api/place/search/json'
    SPOT_URL = 'https://maps.googleapis.com/maps/api/place/details/json'
    SPOTS_LIST_QUERY_URL = 'https://maps.googleapis.com/maps/api/place/textsearch/json'

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
    # @option options [Boolean] :sensor
    #   Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request.
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
      request = new(SPOTS_LIST_URL, options)
      request.parsed_response
    end

    # Search for a Spot with a reference key
    #
    # @return [Spot]
    # @param [Hash] options
    # @option options [String] :key
    #   the provided api key.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :reference
    #   The reference of a already retrieved Spot
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [Boolean] :sensor
    #   Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request.
    #   <b>Note that this is a mandatory parameter</b>
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    #
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    def self.spot(options = {})
      request = new(SPOT_URL, options)
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
    # @option options [Boolean] :sensor
    #   Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request.
    #   <b>Note that this is a mandatory parameter</b>
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
    #
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.spots_by_query(options = {})
      request = new(SPOTS_LIST_QUERY_URL, options)
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
    # @option options [Boolean] :sensor
    #   Indicates whether or not the Place request came from a device using a location sensor (e.g. a GPS) to determine the location sent in this request.
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
    def initialize(url, options)
      retry_options = options.delete(:retry_options) || {}

      retry_options[:status] ||= []
      retry_options[:max]    ||= 0
      retry_options[:delay]  ||= 5

      retry_options[:status] = [retry_options[:status]] unless retry_options[:status].is_a?(Array)

      @response = self.class.get(url, :query => options)

      return unless retry_options[:max] > 0 && retry_options[:status].include?(@response.parsed_response['status'])

      retry_request = proc do
        for i in (1..retry_options[:max])
          sleep(retry_options[:delay])

          @response = self.class.get(url, :query => options)

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
      @response = self.class.get(url, :query => options)
    end

    # Parse errors from the server respons, if any
    # @raise [OverQueryLimitError] when server response object includes status 'OVER_QUERY_LIMIT'
    # @raise [RequestDeniedError] when server response object includes 'REQUEST_DENIED'
    # @raise [InvalidRequestError] when server response object includes 'INVALID_REQUEST'
    # @raise [UnknownError] when server response object includes 'UNKNOWN_ERROR'
    # @return [String] the response from the server as JSON
    def parsed_response
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
      end
    end

  end
end
