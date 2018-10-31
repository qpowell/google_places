require 'spec_helper'
require 'webmock/rspec'

describe GooglePlaces::Request do

  before :each do
    @location = GooglePlaces::Location.new('-33.8670522', '151.1957362').format
    @query = 'Statue of liberty, New York'
    @radius = 200
    @reference = 'CnRsAAAASc4grenwL0h3X5VPNp5fkDNfqbjt3iQtWIPlKS-3ms9GbnCxR_FLHO0B0ZKCgJSg19qymkeHagjQFB4aUL87yhp4mhFTc17DopK1oiYDaeGthztSjERic8TmFNe-6zOpKSdiZWKE6xlQvcbSiWIJchIQOEYZqunSSZqNDoBSs77bWRoUJcMMVANtSlhy0llKI0MI6VcC7DU'
    @reference_not_found = 'CnRpAAAAlO2WvF_4eOqp02TAWKsXpPSCFz8KxBjraWhB4MSvdUPqXN0yCpxQgblam1LeRENcWZF-9-2CEfUwlHUli61PaYe0e7dUPAU302tk6KkalnKqx7nv07iFA1Ca_Y1WoCLH9adEWwkxKMITlbGhUUz9-hIQPxQ4Bp_dz5nHloUFkj3rkBoUDSPqy2smqMnPEo4ayfbDupeKEZY'
    @keyword = 'attractions'
  end

  context 'Listing spots', vcr: { cassette_name: 'list_spots' } do
    context 'with valid options' do
      it 'should retrieve a list of spots' do
        response = GooglePlaces::Request.spots(
          :location => @location,
          :radius => @radius,
          :key => api_key
        )
        expect(response['results']).to_not be_empty
      end
    end
    context 'without location' do
      context 'without retry options' do
        it do
          expect(lambda {
            GooglePlaces::Request.spots(
              :radius => @radius,
              :key => api_key
            )
          }).to raise_error GooglePlaces::InvalidRequestError
        end
      end
      context 'with retry options' do
        context 'without timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spots(
                :radius => @radius,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }).to raise_error GooglePlaces::RetryError
          end
        end
        context 'with timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spots(
                :radius => @radius,
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }).to raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end


  context 'Listing spots by query', vcr: { cassette_name: 'list_spots' } do

    context 'with valid options' do
      it 'should retrieve a list of spots' do
        response = GooglePlaces::Request.spots_by_query(
          :query => @query,
          :key => api_key
        )

        expect(response['results']).to_not be_empty
      end
    end

    context 'without query' do
      context 'without retry options' do
        it do
          expect(lambda {
            GooglePlaces::Request.spots_by_query(
              :key => api_key
            )
          }).to raise_error GooglePlaces::InvalidRequestError
        end
      end

      context 'with retry options' do
        context 'without timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spots_by_query(
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }).to raise_error GooglePlaces::RetryError
          end
        end

        context 'with timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spots_by_query(
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }).to raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end

  context 'Spot details', vcr: { cassette_name: 'single_spot' } do
    context 'with valid options' do
      it 'should retrieve a single spot' do
        response = GooglePlaces::Request.spot(
          :reference => @reference,
          :key => api_key
        )
        expect(response['result']).to_not be_empty
      end
      context 'with reference not found' do
        it 'to raise not found error' do
          expect(lambda {
            GooglePlaces::Request.spot(
              :reference => @reference_not_found,
              :key => api_key
            )
          }).to raise_error GooglePlaces::NotFoundError
        end
      end
    end
    context 'with missing reference' do
      context 'without retry options' do
        it do
          expect(lambda {
            GooglePlaces::Request.spot(
              :key => api_key
            )
          }).to raise_error GooglePlaces::InvalidRequestError
        end
      end
      context 'with retry options' do
        context 'without timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spot(
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 1
                }
              )
            }).to raise_error GooglePlaces::RetryError
          end
        end
        context 'with timeout' do
          it do
            expect(lambda {
              GooglePlaces::Request.spot(
                :key => api_key,
                :retry_options => {
                  :max => 3,
                  :status => 'INVALID_REQUEST',
                  :delay => 10,
                  :timeout => 1
                }
              )
            }).to raise_error GooglePlaces::RetryTimeoutError
          end
        end
      end
    end
  end

  context 'with an API key not authorized to use the Places API' do
    it 'includes the error_message in the exception' do
      stub_request(:get, "https://maps.googleapis.com/maps/api/place/details/json").
        with(query: { reference: @reference, key: api_key }).
        to_return(body: JSON.dump({ status: 'REQUEST_DENIED', error_message: 'This API project is not authorized to use this API. Please ensure that this API is activated in the APIs Console: Learn more: https://code.google.com/apis/console' }))

      expect(lambda {
        GooglePlaces::Request.spot(
          :reference => @reference,
          :key => api_key
        )
      }).to raise_error GooglePlaces::RequestDeniedError, 'This API project is not authorized to use this API. Please ensure that this API is activated in the APIs Console: Learn more: https://code.google.com/apis/console'
    end
  end

  context 'with an HTTP 502 response', vcr: { cassette_name: 'http_502' } do
    it 'correctly handles the exception' do
      stub_const("GooglePlaces::Request::DETAILS_URL", 'http://httpstat.us/502')

      expect(lambda {
        GooglePlaces::Request.spot(
          :reference => @reference,
          :key => api_key
        )
      }).to raise_error GooglePlaces::APIConnectionError
    end
  end
end
