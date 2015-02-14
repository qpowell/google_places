require 'spec_helper'

describe GooglePlaces::Prediction, vcr: { cassette_name: 'list_predictions'}  do
  it "should be a collection of Prediction" do
    collection = GooglePlaces::Prediction.list_by_input('query', api_key)

    expect(collection.map(&:class).uniq).to eq [GooglePlaces::Prediction]
  end

  describe 'requests' do
    before(:each) do
      allow(GooglePlaces::Request).to receive(:predictions_by_input).and_return('predictions' => [])
    end

    it "initiates a request with `radius`" do
      options = request_params(radius: 20, location: "1.00000000,2.00000000")
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, lat: 1, lng: 2, radius: 20)
    end

    it "initiates a request with `types`" do
      options = request_params(types: '(cities)')
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, types: '(cities)')
    end

    it "initiates a request with `language`" do
      options = request_params(language: 'es')
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, language: 'es')
    end

    it "initiates a request with `types` joind by |" do
      options = request_params(types: 'establishment|geocode')
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, types: ['establishment', 'geocode'])
    end

    it "initiates a request with `retry_options`" do
      options = request_params(retry_options: { max: 10, delay: 15 })
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, retry_options: { max: 10, delay: 15 })
    end

    it "initiates a request with `components`" do
      options = request_params(components: 'country:in')
      expect(GooglePlaces::Request).to receive(:predictions_by_input).with(options)

      GooglePlaces::Prediction.list_by_input('query', api_key, components: 'country:in')
    end

  end

  def request_params(options = {})
    {
      input: "query",
      key: api_key,
      retry_options: {}
    }.merge(options)
  end
end
