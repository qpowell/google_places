require 'spec_helper'

describe GooglePlaces::Client do

  it 'should initialize with an api_key' do
    @client = GooglePlaces::Client.new(api_key)
    @client.api_key.should == api_key
  end

  it 'should request spots' do
    lat, lng = '-33.8670522', '151.1957362'
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:list).with(lat, lng, api_key, false, {})

    @client.spots(lat, lng)
  end

  it 'should request a single spot' do
    reference = "CoQBeAAAAO-prCRp9Atcj_rvavsLyv-DnxbGkw8QyRZb6Srm6QHOcww6lqFhIs2c7Ie6fMg3PZ4PhicfJL7ZWlaHaLDTqmRisoTQQUn61WTcSXAAiCOzcm0JDBnafqrskSpFtNUgzGAOx29WGnWSP44jmjtioIsJN9ik8yjK7UxP4buAmMPVEhBXPiCfHXk1CQ6XRuQhpztsGhQU4U6-tWjTHcLSVzjbNxoiuihbaA"
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:find).with(reference, api_key, false, {})

    @client.spot(reference)
  end

  it 'should request spots by query' do
    query = "Statue of liberty, New York"
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:list_by_query).with(query, api_key, false, {})

    @client.spots_by_query(query)
  end

  it 'should request spots by radar' do
    keywords = "landmarks"
    lat, lng = '51.511627', '-0.183778'
    radius = 5000
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Spot.should_receive(:list_by_radar).with(lat, lng, api_key, false, {:radius=> radius, :keyword =>  keywords})

    @client.spots_by_radar(lat, lng, :radius => radius, :keyword =>  keywords)
  end

  it 'should request predictions by input' do
    input = 'Atlanta'
    @client = GooglePlaces::Client.new(api_key)
    GooglePlaces::Prediction.should_receive(:list_by_input).with(input, api_key, {})

    @client.predictions_by_input(input)
  end
end
