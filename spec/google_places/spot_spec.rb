require 'spec_helper'

describe GooglePlaces::Spot do

  before :each do
    @lat = '-33.8670522'
    @lng = '151.1957362'
    @radius = 200
    @pagetoken = 'CmRVAAAAqKK43TjXKnyEx4-XTWd4bC-iBq88Olspwga_JQbEpznYpfwXYbWBrxmb-1QYD4DMtq8gym5YruCEVjByOlKn8PWKQO5fHvuYD8rWKHUeBvMleM7k3oh9TUG8zqcyuhPmEhCG_C2XuypmkQ20hRvxro4sGhQN3nbWCjgpjyG_E_ayjVIoTGbViw'
    @place_id = 'ChIJN1t_tDeuEmsRUsoyG83frY4'
  end

  context 'List spots options', vcr: { cassette_name: 'list_spots_rankby_and_radius' } do
    after :each do
      @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :rankby => "prominence", :radius => @radius)
    end

    it 'should send radius and rankby options' do
      expect(GooglePlaces::Spot).to receive(:multi_pages_request).with(
        :spots,
        false,
        {
          location: "-33.86705220,151.19573620",
          radius: 200,
          rankby: "prominence",
          key: RSPEC_API_KEY,
          name: nil,
          language: nil,
          keyword: nil,
          retry_options: {}
        })
    end

  end

  context 'List spots', vcr: { cassette_name: 'list_spots' } do

    after(:each) do
      expect(@collection.map(&:class).uniq).to eq [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius)
    end

    describe 'with a single type', vcr: { cassette_name: 'list_spots_with_single_type' } do
      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :types => 'cafe')
      end

      it 'should have Spots with a specific type' do
        @collection.each do |spot|
          expect(spot.types).to include('cafe')
        end
      end
    end

    describe 'with multiple types', vcr: { cassette_name: 'list_spots_with_multiple_types' } do
      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :types => ['food','establishment'])
      end

      it 'should have Spots with specific types' do
        @collection.each do |spot|
          expect(spot.types & ['food', 'establishment']).to be_any
        end
      end
    end

    describe 'searching by name and types', vcr: { cassette_name: 'list_spots_with_name_and_types' } do

      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :types => ['food','establishment'], :name => 'italian')
      end

      it 'should have Spots with specific types' do
        @collection.each do |spot|
          expect(spot.types & ['food', 'establishment']).to be_any
        end
      end
    end

    describe 'searching by types with exclusion', vcr: { cassette_name: 'list_spots_with_types_and_exclusion' } do

      it 'should exclude spots with type "restaurant"' do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :types => ['food','establishment'], :exclude => 'restaurant')

        @collection.map(&:types).each do |types|
          expect(types).to_not include('restaurant')
        end
      end

      it 'should exclude spots with type "restaurant" and "cafe"' do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, :radius => @radius, :types => ['food','establishment'], :exclude => ['restaurant', 'cafe'])

        @collection.map(&:types).each do |types|
          expect(types).to_not include('restaurant')
          expect(types).to_not include('cafe')
        end
      end
    end
  end

  context 'Multiple page request', vcr: { cassette_name: 'multiple_page_request' } do

    it 'should return >20 results when :multipage_request is true' do
      @collection = GooglePlaces::Spot.list_by_query('wolfgang', api_key, :lat => '40.808235', :lng => '-73.948733', :radius => @radius, :multipage => true)
      expect(@collection.size).to be >= 21
    end

    it 'should return at most 20 results when :multipage is false' do
      @collection = GooglePlaces::Spot.list_by_query('wolfgang', api_key, :lat => '40.808235', :lng => '-73.948733', :radius => @radius, :multipage => false)
      expect(@collection.size).to be <= 20
    end

    it 'should return at most 20 results when :multipage is not present' do
      @collection = GooglePlaces::Spot.list_by_query('wolfgang', api_key, :lat => '40.808235', :lng => '-73.948733', :radius => @radius)
      expect(@collection.size).to be <= 20
    end

    it 'should return a pagetoken when there is more than 20 results and :multipage is false' do
      @collection = GooglePlaces::Spot.list_by_query('wolfgang', api_key, :lat => '40.808235', :lng => '-73.948733', :radius => @radius, :multipage => false)
      expect(@collection.last.nextpagetoken).to_not be_nil
    end

    it 'should return some results when :pagetoken is present' do
      @collection = GooglePlaces::Spot.list_by_pagetoken(@pagetoken, api_key)
      expect(@collection.size).to be >= 1
    end

  end

  context 'List spots by query', vcr: { cassette_name: 'list_spots' } do

    after(:each) do
      expect(@collection.map(&:class).uniq).to eq [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list_by_query('Statue of liberty, New York', api_key)
    end

  end

  context 'List spots by radar', vcr: { cassette_name: 'list_spots_by_radar' } do

    after(:each) do
      expect(@collection.map(&:class).uniq).to eq [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list_by_radar('48.8567', '2.3508', api_key, :radius => @radius, :keyword => 'attractions')
    end

  end

  context 'Find a single spot', vcr: { cassette_name: 'single_spot' } do
    before :each do
      @spot = GooglePlaces::Spot.find(@place_id, api_key)
    end
    it 'should be a Spot' do
      expect(@spot.class).to eq(GooglePlaces::Spot)
    end
    %w(reference vicinity lat lng viewport name icon types id formatted_phone_number international_phone_number formatted_address address_components street_number street city region postal_code country rating url types website price_level opening_hours events utc_offset place_id).each do |attribute|
      it "should have the attribute: #{attribute}" do
        expect(@spot.respond_to?(attribute)).to eq(true)
      end

      it "should respond to ['#{attribute}']" do
        expect { @spot[attribute] }.to_not raise_error
      end

      it "should respond to [:#{attribute}]" do
        expect { @spot[attribute.to_sym] }.to_not raise_error
      end
    end
    it 'should contain 5 reviews' do
      @spot.reviews.size == 5
    end
    %w(rating type author_name author_url text time).each do |attribute|
      it "should have the review attribute: #{attribute}" do
        expect(@spot.reviews[0].respond_to?(attribute)).to eq(true)
      end
    end
  end
end
