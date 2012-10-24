module GooglePlaces
  class OverQueryLimitError < HTTParty::ResponseError
  end

  # Thrown when a request was denied by the server
  #
  # This can be the case when:
  # - querying the SPOT_LIST_URL <b>without</b> the following parameters:
  # - - key
  # - - sensor
  class RequestDeniedError < HTTParty::ResponseError
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
end
