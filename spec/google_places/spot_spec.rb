require 'spec_helper'

describe GooglePlaces::Spot do

  before :each do
    @lat = '-33.8670522'
    @lng = '151.1957362'
    @radius = 200
    @sensor = false
    @reference = "CnRsAAAASc4grenwL0h3X5VPNp5fkDNfqbjt3iQtWIPlKS-3ms9GbnCxR_FLHO0B0ZKCgJSg19qymkeHagjQFB4aUL87yhp4mhFTc17DopK1oiYDaeGthztSjERic8TmFNe-6zOpKSdiZWKE6xlQvcbSiWIJchIQOEYZqunSSZqNDoBSs77bWRoUJcMMVANtSlhy0llKI0MI6VcC7DU"
    @pagetoken = "CmRVAAAAqKK43TjXKnyEx4-XTWd4bC-iBq88Olspwga_JQbEpznYpfwXYbWBrxmb-1QYD4DMtq8gym5YruCEVjByOlKn8PWKQO5fHvuYD8rWKHUeBvMleM7k3oh9TUG8zqcyuhPmEhCG_C2XuypmkQ20hRvxro4sGhQN3nbWCjgpjyG_E_ayjVIoTGbViw"
  end

  context 'List spots' do
    use_vcr_cassette 'list_spots'

    after(:each) do
      @collection.map(&:class).uniq.should == [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius)
    end

    describe 'with a single type' do
      use_vcr_cassette 'list_spots_with_single_type'

      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :types => 'cafe')
      end

      it 'should have Spots with a specific type' do
        @collection.each do |spot|
          spot.types.should include('cafe')
        end
      end
    end

    describe 'with multiple types' do
      use_vcr_cassette 'list_spots_with_multiple_types'

      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :types => ['food','establishment'])
      end

      it 'should have Spots with specific types' do
        @collection.each do |spot|
          (spot.types & ['food', 'establishment']).should be_any
        end
      end
    end

    describe 'searching by name' do
      use_vcr_cassette 'list_spots_with_name'

      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :name => 'italian')
      end

      # Apparently the Google Places API returns spots with
      # other names than "italian" as well. Disabled this
      # test for now.
      it 'should have Spots with a specific name' do
        pending 'Disabled due to unpredictable API results'

        #@collection.each do |spot|
        #  spot.name.downcase.should include('italian')
        #end
      end
    end

    describe 'searching by name and types' do
      use_vcr_cassette 'list_spots_with_name_and_types'

      before(:each) do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :types => ['food','establishment'], :name => 'italian')
      end

      # Apparently the Google Places API returns spots with
      # other names than "italian" as well. Disabled this
      # test for now.
      it 'should have Spots with a specific name' do
        pending 'Disabled due to unpredictable API results'

        #@collection.each do |spot|
        #  spot.name.downcase.should include('italian')
        #end
      end

      it 'should have Spots with specific types' do
        @collection.each do |spot|
          (spot.types & ['food', 'establishment']).should be_any
        end
      end
    end

    describe 'searching by types with exclusion' do
      use_vcr_cassette 'list_spots_with_types_and_exclusion'

      it 'should exclude spots with type "restaurant"' do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :types => ['food','establishment'], :exclude => 'restaurant')

        @collection.map(&:types).each do |types|
          types.should_not include('restaurant')
        end
      end

      it 'should exclude spots with type "restaurant" and "cafe"' do
        @collection = GooglePlaces::Spot.list(@lat, @lng, api_key, @sensor, :radius => @radius, :types => ['food','establishment'], :exclude => ['restaurant', 'cafe'])

        @collection.map(&:types).each do |types|
          types.should_not include('restaurant')
          types.should_not include('cafe')
        end
      end
    end

    describe 'working with premium data' do
      use_vcr_cassette 'premium_list_spots_with_data'

      it 'should return data with zagat_selected flag only' do
        # hardcoded coordinates & options to get non-zero results count
        @collection = GooglePlaces::Spot.list('39.60049820', '-106.52202606', 'DUMMY_KEY', @sensor, :radius => @radius, :zagat_selected => true, :types => ['restaurant','cafe'], :radius => 20000)

        @collection.map(&:zagat_selected).uniq.should eq [true]


        @collection.map(&:zagat_reviewed).uniq.should eq [true]
      end

      it 'should return data with zagat_selected flag only' do
        # hardcoded coordinates & options to get non-zero results count
        @collection = GooglePlaces::Spot.list('39.60049820', '-106.52202606', 'DUMMY_KEY', @sensor, :radius => @radius, :zagat_selected => true, :types => ['restaurant','cafe'], :radius => 20000)

        item = @collection.detect {|item| item.zagat_reviewed == true}
        item = GooglePlaces::Spot.find(item.reference, 'DUMMY_KEY', @sensor, :review_summary => true)
        item.review_summary.should_not eq nil
      end
    end
  end

  context 'Multiple page request' do
    use_vcr_cassette 'multiple_page_request'

    it 'should return >20 results when :multipage_request is true' do
      @collection = GooglePlaces::Spot.list_by_query("wolfgang", api_key, @sensor, :lat => "40.808235", :lng => "-73.948733", :radius => @radius, :multipage => true)
      @collection.should have_at_least(21).places
    end

    it 'should return at most 20 results when :multipage is false' do
      @collection = GooglePlaces::Spot.list_by_query("wolfgang", api_key, @sensor, :lat => "40.808235", :lng => "-73.948733", :radius => @radius, :multipage => false)
      @collection.should have_at_most(20).places
    end

    it 'should return at most 20 results when :multipage is not present' do
      @collection = GooglePlaces::Spot.list_by_query("wolfgang", api_key, @sensor, :lat => "40.808235", :lng => "-73.948733", :radius => @radius)
      @collection.should have_at_most(20).places
    end

    it 'should return a pagetoken when there is more than 20 results and :multipage is false' do
      @collection = GooglePlaces::Spot.list_by_query("wolfgang", api_key, @sensor, :lat => "40.808235", :lng => "-73.948733", :radius => @radius, :multipage => false)
      @collection.last.nextpagetoken.should_not be_nil
    end

    it 'should return some results when :pagetoken is present' do
      @collection = GooglePlaces::Spot.list_by_pagetoken(@pagetoken, api_key, @sensor)
      @collection.should have_at_least(1).places
    end

  end

  context 'List spots by query' do
    use_vcr_cassette 'list_spots'

    after(:each) do
      @collection.map(&:class).uniq.should == [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list_by_query("Statue of liberty, New York", api_key, @sensor)
    end

  end

  context 'List spots by radar' do
    use_vcr_cassette 'list_spots_by_radar'

    after(:each) do
      @collection.map(&:class).uniq.should == [GooglePlaces::Spot]
    end

    it 'should be a collection of Spots' do
      @collection = GooglePlaces::Spot.list_by_radar('48.8567', '2.3508', api_key, @sensor, :radius => @radius, :keyword => 'attractions')
    end

  end

  context 'Find a single spot' do
    use_vcr_cassette 'single_spot'
    before :each do
      @spot = GooglePlaces::Spot.find(@reference, api_key, @sensor)
    end
    it 'should be a Spot' do
      @spot.class.should == GooglePlaces::Spot
    end
    %w(reference vicinity lat lng name icon types id formatted_phone_number international_phone_number formatted_address address_components street_number street city region postal_code country rating url types website price_level opening_hours events utc_offset place_id).each do |attribute|
      it "should have the attribute: #{attribute}" do
        @spot.respond_to?(attribute).should == true
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
        @spot.reviews[0].respond_to?(attribute).should be true
      end
    end
  end
end
