# frozen_string_literal: true

# Weather Controller Specs

require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe '#weather' do
    it 'calls WeatherDetailsService with permitted params' do
      address = 'New York, NY'
      allow(controller).to receive(:permited_params).and_return(address: address)

      weather_fetch_service = instance_double(WeatherDetailsService, call: nil)
      allow(WeatherDetailsService).to receive(:new).with(address: address).and_return(weather_fetch_service)

      get :weather

      expect(weather_fetch_service).to have_received(:call)
    end

    it 'renders the index template' do
      allow(controller).to receive(:permited_params).and_return(address: 'New York, NY')
      allow_any_instance_of(WeatherDetailsService).to receive(:call)

      get :weather

      expect(response).to render_template(:index)
    end
  end

  describe '#permited_params' do
    it 'requires address parameter' do
      params = ActionController::Parameters.new(address: 'New York, NY')
      allow(controller).to receive(:params).and_return(params)

      expect { controller.send(:permited_params) }.not_to raise_error
    end

    it 'raises an error if address parameter is missing' do
      params = ActionController::Parameters.new(other_param: 'value')
      allow(controller).to receive(:params).and_return(params)

      expect { controller.send(:permited_params) }.to raise_error(ActionController::ParameterMissing)
    end
  end
end
