module GooglePlaces
  class OverQueryLimitError < HTTParty::ResponseError
  end

  # Thrown when a request was denied by the server
  #
  # This can be the case when:
  # - API key is not authorized for the Places API
  # - querying the SPOT_LIST_URL <b>without</b> the following parameters:
  # - - key
  class RequestDeniedError < HTTParty::ResponseError
    def to_s
      response.parsed_response['error_message']
    end
  end

  # Thrown when a request was rejected as invalid by the server
  #
  # This can be the case when:
  # - querying the SPOT_LIST_URL <b>without</b> the following parameters:
  # - - location
  # - - radius
  class InvalidRequestError < HTTParty::ResponseError
  end

  class RetryError < HTTParty::ResponseError
  end

  class RetryTimeoutError < HTTParty::ResponseError
  end

  class UnknownError < HTTParty::ResponseError
  end

  class NotFoundError < HTTParty::ResponseError
  end

  # Thrown when the server returns any 5xx error
  #
  # This can be the case when:
  # - There is a network problem between this gem and Google's API servers
  # - Google's API is broken
  class APIConnectionError < HTTParty::ResponseError
  end
end
