require 'spec_helper'

describe GooglePlaces::Rectangle do
  it 'should return two lat/lng pairs separated by a "|" based on SW and NE lat/lng bounds' do
    expect(GooglePlaces::Rectangle.new('123', '456', '321', '654').format).to eq('123.00000000,456.00000000|321.00000000,654.00000000')
  end
end
