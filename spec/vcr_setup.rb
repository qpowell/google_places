require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/vcr_cassettes'
  c.hook_into                  :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
  c.configure_rspec_metadata!
end
