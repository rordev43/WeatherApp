# spec/services/address_parsing_service_spec.rb

require 'rails_helper'

RSpec.describe AddressParsingService, type: :service do
  describe '#call' do
    context 'with a valid address' do
      let(:valid_address) { '1600 Amphitheatre Parkway, Mountain View, CA' }

      it 'returns the best location' do
        geocodio_response = double('geocodio_response', best: { 'formatted_address' => 'Valid Address' })
        allow_any_instance_of(Geocodio::Client).to receive(:geocode).with([valid_address]).and_return(geocodio_response)

        service = AddressParsingService.new(valid_address)
        result = service.call

        expect(result['formatted_address']).to eq('Valid Address')
      end
    end

    context 'with an invalid address' do
      let(:invalid_address) { 'Invalid Address' }

      it 'logs the error and raises StandardError' do
        error_response = double('error_response', body: '{"error": "Geocodio error message"}')
        allow_any_instance_of(Geocodio::Client).to receive(:geocode).with([invalid_address])
                                          .and_raise(Geocodio::Client::Error.new(error_response))

        expect(Rails.logger).to receive(:error).with('Geocodio error message')

        service = AddressParsingService.new(invalid_address)
        expect { service.call }.to raise_error(StandardError)
      end
    end

    context 'with missing Geocodio API key' do
      it 'raises StandardError' do
        allow(ENV).to receive(:fetch).with('GEOCODIO_API_KEY', nil).and_return(nil)

        service = AddressParsingService.new('Any Address')
        expect { service.call }.to raise_error(StandardError)
      end
    end
  end
end
