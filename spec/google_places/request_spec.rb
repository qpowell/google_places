require 'spec_helper'

describe GooglePlaces::Request do

  before :each do
    @location = GooglePlaces::Location.new('-33.8670522', '151.1957362').format
    @query = "Statue of liberty, New York"
    @radius = 200
    @sensor = false
    @reference = "CnRsAAAASc4grenwL0h3X5VPNp5fkDNfqbjt3iQtWIPlKS-3ms9GbnCxR_FLHO0B0ZKCgJSg19qymkeHagjQFB4aUL87yhp4mhFTc17DopK1oiYDaeGthztSjERic8TmFNe-6zOpKSdiZWKE6xlQvcbSiWIJchIQOEYZqunSSZqNDoBSs77bWRoUJcMMVANtSlhy0llKI0MI6VcC7DU"
  end

  context 'Listing spots' do
    use_vcr_cassette 'list_spots'
    context 'with valid options' do
      it 'should retrieve a list of spots' do
        response = GooglePlaces::Request.spots(
          :location => @location,
          :radius => @radius,
          :sensor => @sensor,
          :key => api_key
        )
        response['results'].should_not be_empty
      end
    end
    context 'with missing sensor' do
      it do
        lambda {
          GooglePlaces::Request.spots(
            :location => @location,
            :radius => @radius,
            :key => api_key
          )
        }.should raise_error GooglePlaces::RequestDeniedError
      end
    end
    context 'without location' do
      context 'without retry options' do
        it do
          lambda {
            GooglePlaces::Request.spots(
              :radius => @radius,
              :sensor => @sensor,
              :key => api_key
            )
          }.should raise_error GooglePlaces::InvalidRequestError
        end
      end
      context 'with retry options' do
        context 'without timeout' do
          it do
            lambda {
              GooglePlaces::Request.spots(
                :radius => @radius,
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }.should raise_error GooglePlaces::RetryError
          end
        end
        context 'with timeout' do
          it do
            lambda {
              GooglePlaces::Request.spots(
                :radius => @radius,
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }.should raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end


  context 'Listing spots by query' do
    use_vcr_cassette 'list_spots'

    context 'with valid options' do
      it 'should retrieve a list of spots' do
        response = GooglePlaces::Request.spots_by_query(
          :query => @query,
          :sensor => @sensor,
          :key => api_key
        )

        response['results'].should_not be_empty
      end
    end

    context 'with missing sensor' do
      it do
        lambda {
          GooglePlaces::Request.spots_by_query(
            :query => @query,
            :key => api_key
          )
        }.should raise_error GooglePlaces::RequestDeniedError
      end
    end

    context 'without query' do
      context 'without retry options' do
        it do
          lambda {
            GooglePlaces::Request.spots_by_query(
              :sensor => @sensor,
              :key => api_key
            )
          }.should raise_error GooglePlaces::InvalidRequestError
        end
      end

      context 'with retry options' do
        context 'without timeout' do
          it do
            lambda {
              GooglePlaces::Request.spots_by_query(
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }.should raise_error GooglePlaces::RetryError
          end
        end

        context 'with timeout' do
          it do
            lambda {
              GooglePlaces::Request.spots_by_query(
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }.should raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end

  context 'Spot details' do
    use_vcr_cassette 'single_spot'
    context 'with valid options' do
      it 'should retrieve a single spot' do
        response = GooglePlaces::Request.spot(
          :reference => @reference,
          :sensor => @sensor,
          :key => api_key
        )
        response['result'].should_not be_empty
      end
    end
    context 'with missing sensor' do
      it do
        lambda {
          GooglePlaces::Request.spot(
            :reference => @reference,
            :key => api_key
          )
        }.should raise_error GooglePlaces::RequestDeniedError
      end
    end
    context 'with missing reference' do
      context 'without retry options' do
        it do
          lambda {
            GooglePlaces::Request.spot(
              :sensor => @sensor,
              :key => api_key
            )
          }.should raise_error GooglePlaces::InvalidRequestError
        end
      end
      context 'with retry options' do
        context 'without timeout' do
          it do
            lambda {
              GooglePlaces::Request.spot(
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }.should raise_error GooglePlaces::RetryError
          end
        end
        context 'with timeout' do
          it do
            lambda {
              GooglePlaces::Request.spot(
                :sensor => @sensor,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }.should raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end

end
