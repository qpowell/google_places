require 'rubygems'
require 'httparty'

%w(client location request spot error).each do |file|
  require File.join(File.dirname(__FILE__), 'google_places', file)
end

module GooglePlaces
  class << self

    attr_accessor :api_key

    def configuration
      yield self
    end

  end
end
