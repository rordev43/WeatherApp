# spec/services/weather_fetch_service_spec.rb

require 'rails_helper'

RSpec.describe WeatherDetailsService, type: :service do
  describe '#call' do
    context 'with a valid address' do
      let(:valid_address) { '1600 Amphitheatre Parkway, Mountain View, CA' }

      it 'fetches weather from the API' do
        parsed_address_response = Geocodio::Address.new(
          number: '1',
          street: 'Infinite',
          suffix: 'Loop',
          city: 'Monta Vista',
          state: 'CA',
          zip: '95014',
          latitude: 37.331669,
          longitude: -122.03074,
          accuracy: 1,
          formatted_address: '1 Infinite Loop, Monta Vista CA, 95014'
        )

        allow_any_instance_of(AddressParsingService).to receive(:call).and_return(parsed_address_response)

        api_response = double('api_response', status: 200, body: '{"weather": "sunny"}')
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(api_response)

        allow($redis).to receive(:get).and_return(nil)
        allow($redis).to receive(:setex)

        service = WeatherDetailsService.new(valid_address)
        result = service.call

        expect(result).to eq('weather' => 'sunny', 'is_cached' => false)
      end

      it 'returns cached weather' do
        parsed_address_response = Geocodio::Address.new(
          number: '1',
          street: 'Infinite',
          suffix: 'Loop',
          city: 'Monta Vista',
          state: 'CA',
          zip: '95014',
          latitude: 37.331669,
          longitude: -122.03074,
          accuracy: 1,
          formatted_address: '1 Infinite Loop, Monta Vista CA, 95014'
        )

        allow_any_instance_of(AddressParsingService).to receive(:call).and_return(parsed_address_response)

        cached_response = '{"weather": "cached_weather", "is_cached": true}'
        allow($redis).to receive(:get).and_return(cached_response)

        service = WeatherDetailsService.new(valid_address)
        result = service.call

        expect(result).to eq('weather' => 'cached_weather', 'is_cached' => true)
      end
    end

    context 'with missing OpenWeather API key' do
      it 'raises StandardError' do
        allow(ENV).to receive(:fetch).with('OPEN_WEATHER_API_KEY', nil).and_return(nil)
        allow(ENV).to receive(:fetch).with('GEOCODIO_API_KEY', nil).and_return(nil)

        expect { WeatherDetailsService.new('Any Address').call }.to raise_error(StandardError, 'Invaild Address')
      end
    end
  end
end
