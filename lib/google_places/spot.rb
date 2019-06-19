require 'google_places/review'
module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :viewport, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number,
    :international_phone_number, :formatted_address, :address_components, :street_number, :street, :city, :region,
    :postal_code, :country, :rating, :url, :cid, :website, :reviews, :aspects, :zagat_selected, :zagat_reviewed,
    :photos, :review_summary, :nextpagetoken, :price_level, :opening_hours, :events, :utc_offset, :place_id, :permanently_closed,
    :json_result_object

    # Search for Spots at the provided location
    #
    # @return [Array<Spot>]
    # @param [String,Integer] lat the latitude for the search
    # @param [String,Integer] lng the longitude for the search
    # @param [String] api_key the provided api key
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
    # @see http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 List of supported languages
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.list(lat, lng, api_key, options = {})
      location = Location.new(lat, lng)
      multipage_request = !!options.delete(:multipage)
      rankby = options.delete(:rankby)
      radius = options.delete(:radius) || 1000 if rankby.nil? || rankby =~ /prominence/
      types  = options.delete(:types)
      name  = options.delete(:name)
      keyword = options.delete(:keyword)
      language  = options.delete(:language)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}
      zagat_selected = options.delete(:zagat_selected) || false
      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :location => location.format,
        :radius => radius,
        :rankby => rankby,
        :key => api_key,
        :name => name,
        :language => language,
        :keyword => keyword,
        :retry_options => retry_options
      }

      options[:zagatselected] = zagat_selected if zagat_selected

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      request(:spots, multipage_request, exclude, options)
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
      #
      # @option options [Hash] :retry_options ({})
      #   A Hash containing parameters for search retries
      # @option options [Object] :retry_options[:status] ([])
      # @option options [Integer] :retry_options[:max] (0) the maximum retries
      # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
      #
      # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.list_by_bounds(bounds, api_key, options = {})
      start_lat = bounds[:start_point][:lat]
      start_lng = bounds[:start_point][:lng]
      end_lat = bounds[:end_point][:lat]
      end_lng = bounds[:end_point][:lng]
      rect = Rectangle.new(start_lat, start_lng, end_lat, end_lng)
      multipage_request = !!options.delete(:multipage)
      rankby = options.delete(:rankby)
      query  = options.delete(:query)
      name  = options.delete(:name)
      language  = options.delete(:language)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}
      zagat_selected = options.delete(:zagat_selected) || false
      exclude = [exclude] unless exclude.is_a?(Array)


      options = {
        :bounds => rect.format,
        :key => api_key,
        :language => language,
        :retry_options => retry_options
      }

      options[:zagatselected] = zagat_selected if zagat_selected

      # Accept Types as a string or array
      if query
        query = (query.is_a?(Array) ? query.join('|') : query)
        options.merge!(:query => query)
      end

      request(:spots_by_bounds, multipage_request, exclude, options)
    end
    # Search for Spots using Radar Search. Spots will only include reference and lat/lng information. You can send a Place Details request for more information about any of them.
    #
    # @return [Array<Spot>]
    # @param [String,Integer] lat the latitude for the search
    # @param [String,Integer] lng the longitude for the search
    # @param [String] api_key the provided api key
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
    # @option options [Hash] :retry_options ({})
    #   A Hash containing parameters for search retries
    # @option options [Object] :retry_options[:status] ([])
    # @option options [Integer] :retry_options[:max] (0) the maximum retries
    # @option options [Integer] :retry_options[:delay] (5) the delay between each retry in seconds
    #
    # @see https://developers.google.com/places/documentation/search#RadarSearchRequests Radar Search
    # @see https://developers.google.com/maps/documentation/places/supported_types List of supported types
    def self.list_by_radar(lat, lng, api_key, options = {})
      location = Location.new(lat, lng)
      multipage_request = !!options.delete(:multipage)
      radius = options.delete(:radius) || 1000
      types  = options.delete(:types)
      name  = options.delete(:name)
      keyword = options.delete(:keyword)
      retry_options = options.delete(:retry_options) || {}
      zagat_selected = options.delete(:zagat_selected) || false
      opennow = options.delete(:opennow) || false
      minprice = options.delete(:minprice) || false
      maxprice = options.delete(:maxprice) || false
      exclude = []

      options = {
        :location => location.format,
        :radius => radius,
        :key => api_key,
        :name => name,
        :keyword => keyword,
        :retry_options => retry_options
      }

      options[:zagatselected] = zagat_selected if zagat_selected
      options[:opennow] = opennow if opennow
      options[:minprice] = minprice if minprice
      options[:maxprice] = maxprice if maxprice

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      request(:spots_by_radar, multipage_request, exclude, options)
    end



    # Search for a Spot with a reference key
    #
    # @return [Spot]
    # @param [String] place_id the place_id of the spot
    # @param [String] api_key the provided api key
    # @param [Hash] options
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
    def self.find(place_id, api_key, options = {})
      fields = options.delete(:fields)
      language  = options.delete(:language)
      region = options.delete(:region)
      retry_options = options.delete(:retry_options) || {}
      extensions = options.delete(:review_summary) ? 'review_summary' : nil

      request_options = {
        :placeid => place_id,
        :key => api_key,
        :language => language,
        :extensions => extensions,
        :retry_options => retry_options,
        :fields => fields
      }
      request_options[:region] = region unless region.nil?
      response = Request.spot(request_options)

      self.new(response['result'], api_key)
    end

    # Search for Spots with a pagetoken
    #
    # @return [Array<Spot>]
    # @param [String] pagetoken the token to find next results
    # @param [String] api_key the provided api key
    # @param [Hash] options
    def self.list_by_pagetoken(pagetoken, api_key, options = {})
      exclude = options.delete(:exclude) || []
      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
          :pagetoken => pagetoken,
          :key => api_key
      }

      request(:spots_by_pagetoken, false, exclude, options)
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
    def self.list_by_query(query, api_key, options = {})
      if options.has_key?(:lat) && options.has_key?(:lng)
        with_location = true
      else
        with_location = false
      end

      if options.has_key?(:radius)
        with_radius = true
      else
        with_radius = false
      end

      query = query
      multipage_request = !!options.delete(:multipage)
      location = Location.new(options.delete(:lat), options.delete(:lng)) if with_location
      radius = options.delete(:radius) if with_radius
      rankby = options.delete(:rankby)
      language = options.delete(:language)
      region = options.delete(:region)
      types = options.delete(:types)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :query => query,
        :key => api_key,
        :rankby => rankby,
        :language => language,
        :retry_options => retry_options
      }

      options[:location] = location.format if with_location
      options[:radius] = radius if with_radius
      options[:region] = region unless region.nil?

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      request(:spots_by_query, multipage_request, exclude, options)
    end

    def self.request(method, multipage_request, exclude, options)
      results = []

      self.multi_pages_request(method, multipage_request, options) do |result|
      	# Some places returned by Google do not have a 'types' property. If the user specified 'types', then
      	# this is a non-issue because those places will not be returned. However, if the user did not specify
      	# 'types', then we do not want to filter out places with a missing 'types' property from the results set.
        results << self.new(result, options[:key]) if result['types'].nil? || (result['types'] & exclude) == []
      end

      results
    end

    def self.multi_pages_request(method, multipage_request, options)
      begin
        response = Request.send(method, options)
        response['results'].each do |result|
          if !multipage_request && !response["next_page_token"].nil? && result == response['results'].last
            # add next page token on the last result
            result.merge!("nextpagetoken" => response["next_page_token"])
          end
          yield(result)
        end

        # request the next page if presence of a "next_page" token
        next_page = false
        if multipage_request && !response["next_page_token"].nil?
          options = {
            :pagetoken => response["next_page_token"],
            :key => options[:key]
          }

          # There is a short delay between when a next_page_token is issued, and when it will become valid.
          # If requested too early, it will result in InvalidRequestError.
          # See: https://developers.google.com/places/documentation/search#PlaceSearchPaging
          sleep(2)

          next_page = true
        end

      end while (next_page)
    end

    # @param [JSON] json_result_object a JSON object to create a Spot from
    # @return [Spot] a newly created spot
    def initialize(json_result_object, api_key)
      @json_result_object         = json_result_object
      @reference                  = json_result_object['reference']
      @place_id                   = json_result_object['place_id']
      @vicinity                   = json_result_object['vicinity']
      @lat                        = json_result_object['geometry'] ? json_result_object['geometry']['location']['lat'] : nil
      @lng                        = json_result_object['geometry'] ? json_result_object['geometry']['location']['lng'] : nil
      @viewport                   = json_result_object['geometry'] ? json_result_object['geometry']['viewport'] : nil
      @name                       = json_result_object['name']
      @icon                       = json_result_object['icon']
      @types                      = json_result_object['types']
      @id                         = json_result_object['id']
      @formatted_phone_number     = json_result_object['formatted_phone_number']
      @international_phone_number = json_result_object['international_phone_number']
      @formatted_address          = json_result_object['formatted_address']
      @address_components         = json_result_object['address_components']
      @street_number              = address_component(:street_number, 'short_name')
      @street                     = address_component(:route, 'long_name')
      @city                       = address_component(:locality, 'long_name')
      @region                     = address_component(:administrative_area_level_1, 'long_name')
      @postal_code                = address_component(:postal_code, 'long_name')
      @country                    = address_component(:country, 'long_name')
      @rating                     = json_result_object['rating']
      @price_level                = json_result_object['price_level']
      @opening_hours              = json_result_object['opening_hours']
      @url                        = json_result_object['url']
      @cid                        = json_result_object['url'].to_i
      @website                    = json_result_object['website']
      @zagat_reviewed             = json_result_object['zagat_reviewed']
      @zagat_selected             = json_result_object['zagat_selected']
      @aspects                    = aspects_component(json_result_object['aspects'])
      @review_summary             = json_result_object['review_summary']
      @photos                     = photos_component(json_result_object['photos'], api_key)
      @reviews                    = reviews_component(json_result_object['reviews'])
      @nextpagetoken              = json_result_object['nextpagetoken']
      @events                     = events_component(json_result_object['events'])
      @utc_offset                 = json_result_object['utc_offset']
      @permanently_closed         = json_result_object['permanently_closed']
    end

    def [] (key)
      send(key)
    end

    def address_component(address_component_type, address_component_length)
      if component = address_components_of_type(address_component_type)
        component.first[address_component_length] unless component.first.nil?
      end
    end

    def address_components_of_type(type)
      @address_components.select{ |c| c['types'].include?(type.to_s) } unless @address_components.nil?
    end

    def reviews_component(json_reviews)
      if json_reviews
        json_reviews.map { |r|
          Review.new(
              r['rating'],
              r['type'],
              r['author_name'],
              r['author_url'],
              r['text'],
              r['time'].to_i,
              r['profile_photo_url']
          )
        }
      else []
      end
    end

    def aspects_component(json_aspects)
      json_aspects.to_a.map{ |r| { :type => r['type'], :rating => r['rating'] } }
    end

    def photos_component(json_photos, api_key)
      if json_photos
        json_photos.map{ |p|
          Photo.new(
            p['width'],
            p['height'],
            p['photo_reference'],
            p['html_attributions'],
            api_key
          )
        }
      else []
      end
    end

    def events_component(json_events)
      json_events.to_a.map{ |r| {:event_id => r['event_id'], :summary => r['summary'], :url => r['url'], :start_time => r['start_time']} }
    end
  end
end
