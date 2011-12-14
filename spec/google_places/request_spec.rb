require 'spec_helper'

describe GooglePlaces::Request do

  before :each do
    @location = GooglePlaces::Location.new('-33.8670522', '151.1957362').format
    @radius = 200
    @sensor = false
    @reference = "CoQBeAAAAO-prCRp9Atcj_rvavsLyv-DnxbGkw8QyRZb6Srm6QHOcww6lqFhIs2c7Ie6fMg3PZ4PhicfJL7ZWlaHaLDTqmRisoTQQUn61WTcSXAAiCOzcm0JDBnafqrskSpFtNUgzGAOx29WGnWSP44jmjtioIsJN9ik8yjK7UxP4buAmMPVEhBXPiCfHXk1CQ6XRuQhpztsGhQU4U6-tWjTHcLSVzjbNxoiuihbaA"
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
