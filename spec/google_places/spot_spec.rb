require 'spec_helper'

describe GooglePlaces::Spot do

  before :each do
    @lat = '-33.8670522'
    @lng = '151.1957362'
    @radius = 200
    @sensor = false
    @reference = "CoQBeAAAAO-prCRp9Atcj_rvavsLyv-DnxbGkw8QyRZb6Srm6QHOcww6lqFhIs2c7Ie6fMg3PZ4PhicfJL7ZWlaHaLDTqmRisoTQQUn61WTcSXAAiCOzcm0JDBnafqrskSpFtNUgzGAOx29WGnWSP44jmjtioIsJN9ik8yjK7UxP4buAmMPVEhBXPiCfHXk1CQ6XRuQhpztsGhQU4U6-tWjTHcLSVzjbNxoiuihbaA"
  end

  context 'List spots' do
    use_vcr_cassette 'list_spots'

    before :each do
      @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :sensor => @sensor)
    end

    it 'should be a collection of Spots' do
      @collection.map(&:class).uniq.should == [GooglePlaces::Spot]
    end
  end

  context 'Find a single spot' do
    use_vcr_cassette 'single_spot'

    before :each do
      @spot = GooglePlaces::Spot.find(@reference, api_key, :sensor => @sensor)
    end

    it 'should be a Spot' do
      @spot.class.should == GooglePlaces::Spot
    end

    %w(id reference vicinity lat lng name icon).each do |attribute|
      it "should have the attribute: #{attribute}" do
        @spot.send(attribute).should_not be_nil
      end
    end
  end

end
