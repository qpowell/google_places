require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/vcr_cassettes'
  c.hook_into                  :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
  c.configure_rspec_metadata!

  # BODY binary to json ( https://github.com/mislav/movieapp/blob/master/spec/support/vcr.rb )
  bin2ascii = ->(value) {
    if value && 'ASCII-8BIT' == value.encoding.name
      value.force_encoding('us-ascii')
    end
    value
  }

  normalize_headers = ->(headers) {
    headers.keys.each { |key|
      value = headers[key]

      if 'ASCII-8BIT' == key.encoding.name
        old_key, key = key, bin2ascii.(key.dup)
        headers.delete(old_key)
        headers[key] = value
      end

      Array(value).each {|v| bin2ascii.(v) }
      headers[key] = value[0] if Array === value && value.size < 2
    }
  }

  c.before_record do |i|
    if enc = i.response.headers['Content-Encoding'] and 'gzip' == Array(enc).first
      i.response.body = Zlib::GzipReader.new(StringIO.new(i.response.body), encoding: 'ASCII-8BIT').read
      i.response.update_content_length_header
      i.response.headers.delete 'Content-Encoding'
    end

    type, charset = Array(i.response.headers['Content-Type']).join(',').split(';')

    if charset =~ /charset=(\S+)/
      i.response.body.force_encoding($1)
    end

    bin2ascii.(i.response.status.message)

    if type =~ /[\/+]json$/ or 'text/javascript' == type
      begin
        data = JSON.parse i.response.body
      rescue
        warn "VCR: JSON parse error for Content-type #{type}"
      else
        i.response.body = JSON.pretty_generate data
        i.response.update_content_length_header
      end
    end

    normalize_headers.(i.request.headers)
    normalize_headers.(i.response.headers)
  end



end
