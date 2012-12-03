require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/vcr_cassettes'
  c.hook_into                  :fakeweb
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :new_episodes }
end
