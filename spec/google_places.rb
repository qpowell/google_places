require 'spec_helper'

describe GooglePlaces do
  it "should be able to initialize client without any params" do
    client = GooglePlaces::Client.new
    client.api_key.should == nil
  end

  shared_examples "config api_key" do
    it "should be able to config api_key" do
      GooglePlaces.configuration do |config|
        config.api_key = '456'
      end
      client = GooglePlaces::Client.new
      client.api_key.should == '456'
    end
  end

  include_examples "config api_key" do
    it "should be able to config api_key and being overwrite" do
      client = GooglePlaces::Client.new
      client.api_key.should_not == nil
      client = GooglePlaces::Client.new '123'
      client.api_key.should == '123'
    end
  end
end
