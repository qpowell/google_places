require 'spec_helper'

describe GooglePlaces::Photo do

  before :each do
    @max_width = 400
    @sensor = false
    @photo_reference = "CnRtAAAACQQXR83Jc3Pffxt1Zx7QbCe6AfY2negSNzkk2IeSf0q5nxHgartLzkr1fltSlkEDSS-EZqswWAW2eQDbiOl12J-V4Rmn_JNko9e9gSnMwxHBdmScu_84NMSe-0RwB9BM6AEqE8sENXQ8cpWaiEsC_RIQLzIJxpRdoqSPrPtrjTrOhxoUWb8uwObkV4duXfKIiNB20gfnu88"
  end

  context 'Photo' do
    use_vcr_cassette 'photo'
    before :each do
      @photo = GooglePlaces::Photo.new(400, 400, @photo_reference, [], api_key, @sensor)
    end
    it 'should be a Photo' do
      @photo.class.should == GooglePlaces::Photo
    end
    %w(width height photo_reference html_attributions).each do |attribute|
      it "should have the attribute: #{attribute}" do
        @photo.respond_to?(attribute).should == true
      end
    end
    it 'should return a url when fetched' do
      url = @photo.fetch_url(@max_width)
      url.should_not be_empty
    end
  end
end
