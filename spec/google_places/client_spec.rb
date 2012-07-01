require 'spec_helper'

describe GooglePlaces::Client do

  it 'should not initialize without an api_key' do
    lambda { GooglePlaces::Client.new }.should raise_error
  end

  it 'should initialize with an api_key' do
    @client = GooglePlaces::Client.new(api_key)
    @client.api_key.should == api_key
  end

  it 'should request spots' do
    lat, lng = '-33.8670522', '151.1957362'
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:list).with(lat, lng, api_key, {})

    @client.spots(lat, lng)
  end

  it 'should request a single spot' do
    reference = "CoQBeAAAAO-prCRp9Atcj_rvavsLyv-DnxbGkw8QyRZb6Srm6QHOcww6lqFhIs2c7Ie6fMg3PZ4PhicfJL7ZWlaHaLDTqmRisoTQQUn61WTcSXAAiCOzcm0JDBnafqrskSpFtNUgzGAOx29WGnWSP44jmjtioIsJN9ik8yjK7UxP4buAmMPVEhBXPiCfHXk1CQ6XRuQhpztsGhQU4U6-tWjTHcLSVzjbNxoiuihbaA"
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:find).with(reference, api_key, {})

    @client.spot(reference)
  end

  it 'should request spots by query' do
    query = "Statue of liberty, New York"
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:list_by_query).with(query, api_key, {})

    @client.spots_by_query(query)
  end
end
