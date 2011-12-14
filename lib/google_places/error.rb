module GooglePlaces
  class OverQueryLimitError < HTTParty::ResponseError
  end

  class RequestDeniedError < HTTParty::ResponseError
  end

  class InvalidRequestError < HTTParty::ResponseError
  end

  class RetryError < HTTParty::ResponseError
  end

  class RetryTimeoutError < HTTParty::ResponseError
  end
end
