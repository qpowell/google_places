require 'rubygems'
require 'bundler/setup'
require 'vcr_setup'
require 'api_key'
require File.dirname(__FILE__) + '/../lib/' + 'google_places'

def api_key
  RSPEC_API_KEY
end
