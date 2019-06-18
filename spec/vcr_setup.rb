require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/vcr_cassettes'
  c.hook_into                  :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<API_KEY>") { RSPEC_API_KEY }
end
