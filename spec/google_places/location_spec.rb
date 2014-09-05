require 'spec_helper'

describe GooglePlaces::Location do
  it 'should return a location based on a lat and lng' do
    expect(GooglePlaces::Location.new('123', '456').format).to eq('123.00000000,456.00000000')
  end
end
