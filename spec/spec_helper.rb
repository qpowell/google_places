require 'rubygems'
require 'bundler/setup'
require 'vcr_setup'
require 'api_key'
require 'google_places'

def api_key
  RSPEC_API_KEY
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end
