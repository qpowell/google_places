require 'spec_helper'

describe GooglePlaces::Photo do
  before :each do
    @max_width = 400
    @photo_reference = "CnRtAAAACQQXR83Jc3Pffxt1Zx7QbCe6AfY2negSNzkk2IeSf0q5nxHgartLzkr1fltSlkEDSS-EZqswWAW2eQDbiOl12J-V4Rmn_JNko9e9gSnMwxHBdmScu_84NMSe-0RwB9BM6AEqE8sENXQ8cpWaiEsC_RIQLzIJxpRdoqSPrPtrjTrOhxoUWb8uwObkV4duXfKIiNB20gfnu88"
  end

  context 'Photo', vcr: { cassette_name: 'photo'} do
    before :each do
      @photo = GooglePlaces::Photo.new(400, 400, @photo_reference, [], api_key)
    end

    it 'should be a Photo' do
      expect(@photo.class).to eq(GooglePlaces::Photo)
    end

    %w(width height photo_reference html_attributions).each do |attribute|
      it "should have the attribute: #{attribute}" do
        expect(@photo.respond_to?(attribute)).to eq(true)
      end
    end

    it 'should return a url when fetched' do
      url = @photo.fetch_url(@max_width)
      expect(url).to_not be_empty
    end
  end
end
