module GooglePlaces
  class Prediction

    attr_accessor(
      :description,
      :place_id,
      :terms,
      :types,
      :matched_substrings,
      :structured_formatting
    )

    def initialize(json_result_object)
      @description = json_result_object['description']
      @place_id = json_result_object['place_id']
      @terms = json_result_object['terms']
      @types = json_result_object['types']
      @matched_substrings = json_result_object['matched_substrings']
      @structured_formatting = json_result_object['structured_formatting']
    end

    # Query for Predictions (optionally at the provided location)
    #
    # @option [String,Integer] :lat the latitude for the search
    # @option [String,Integer] :lng the longitude for the search
    # @option options [Integer] :radius (1000)
    #   Defines the distance (in meters) within which to return Place results.
    #   The maximum allowed radius is 50,000 meters.
    #   Note that radius must not be included if :rankby => 'distance' (described below) is specified.
    # @option options [String,Array] :types
    #   Restricts the results to Spots matching at least one of the specified types
    # @option options [String] :language
    #   The language code, indicating in which language the results should be returned, if possible.
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    def self.list_by_input(input, api_key, options = {})
      lat = options.delete(:lat)
      lng = options.delete(:lng)
      language = options.delete(:language)
      radius = options.delete(:radius)
      retry_options = options.delete(:retry_options) || {}
      types  = options.delete(:types)
      components = options.delete(:components)

      options = {
        :input => input,
        :key => api_key,
        :retry_options => retry_options
      }

      if lat && lng
        options[:location] = Location.new(lat, lng).format
        options[:radius] = radius if radius
      end

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options[:types] = types
      end

      if language
        options[:language] = language
      end

      if components
        options[:components] = components
      end

      request(:predictions_by_input, options)
    end

    def self.request(method, options)
      response = Request.send(method, options)

      response['predictions'].map do |result|
        self.new(result)
      end
    end
  end
end
