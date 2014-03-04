require 'spec_helper'

describe GooglePlaces::Prediction, '.list_by_input' do
  use_vcr_cassette 'list_predictions'

  it "should be a collection of Prediction" do
    collection = GooglePlaces::Prediction.list_by_input('query', api_key)

    collection.map(&:class).uniq.should == [GooglePlaces::Prediction]
  end

  describe 'requests' do
    before(:each) do
      GooglePlaces::Request.stub(:predictions_by_input).and_return('predictions' => [])
    end

    it "initiates a request with `location` and a default `radius`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:location].should eq('1.00000000,2.00000000')
        options[:radius].should eq(GooglePlaces::Prediction::DEFAULT_RADIUS)
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, lat: 1.00000000, lng: 2.00000000)
    end

    it "initiates a request with `radius`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:radius].should eq(20)
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, lat: 1, lng: 2, radius: 20)
    end

    it "initiates a request with `sensor`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:sensor].should be_true
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, sensor: true)
    end

    it "initiates a request with a default `sensor`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:sensor].should be_false
      end

      GooglePlaces::Prediction.list_by_input('query', api_key)
    end

    it "initiates a request with `types`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:types].should eq('(cities)')
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, types: '(cities)')
    end

    it "initiates a request with `types` joind by |" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:types].should eq('establishment|geocode')
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, types: ['establishment', 'geocode'])
    end

    it "initiates a request with `retry_options`" do
      GooglePlaces::Request.should_receive(:predictions_by_input).with do |options|
        options[:retry_options].should eq(max: 10, delay: 15)
      end

      GooglePlaces::Prediction.list_by_input('query', api_key, retry_options: { max: 10, delay: 15 })
    end
  end
end
