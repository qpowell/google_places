require 'spec_helper'

describe GooglePlaces::Client do
  it 'should initialize with an api_key' do
    @client = GooglePlaces::Client.new(api_key)
    expect(@client.api_key).to eq(api_key)
  end

  it 'should request spots' do
    lat, lng = '-33.8670522', '151.1957362'
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Spot).to receive(:list).with(lat, lng, api_key, {})

    @client.spots(lat, lng)
  end

  it 'should request a single spot by place_id' do
    place_id = 'ChIJu46S-ZZhLxMROG5lkwZ3D7k'
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Spot).to receive(:find).with(place_id, api_key, {})

    @client.spot(place_id)
  end

  it 'should request spots by query' do
    query = 'Statue of liberty, New York'
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Spot).to receive(:list_by_query).with(query, api_key, {})

    @client.spots_by_query(query)
  end
  it 'should request spots by bounds' do
    query = 'pizza'
    bounds = {:start_point => {:lat => '36.06686213257888', :lng => '-86.94168090820312'},
              :end_point => {:lat => '36.268635800737876', :lng => '-86.66152954101562'}}
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Spot).to receive(:list_by_bounds).with(bounds, api_key, {:query => query})
    res = @client.spots_by_bounds(bounds, :query => query)
  end
  it 'should request spots by radar' do
    keywords = 'landmarks'
    lat, lng = '51.511627', '-0.183778'
    radius = 5000
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Spot).to receive(:list_by_radar).with(lat, lng, api_key, {:radius=> radius, :keyword =>  keywords})

    @client.spots_by_radar(lat, lng, :radius => radius, :keyword =>  keywords)
  end

  it 'should request predictions by input' do
    input = 'Atlanta'
    @client = GooglePlaces::Client.new(api_key)
    expect(GooglePlaces::Prediction).to receive(:list_by_input).with(input, api_key, {})

    @client.predictions_by_input(input)
  end
end
