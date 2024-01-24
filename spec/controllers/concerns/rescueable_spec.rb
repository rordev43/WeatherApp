# spec/controllers/concerns/rescuable_spec.rb

require 'rails_helper'

class ApplicationController
  include Rescuable
end

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      raise StandardError.new('Standard error')
    end

    def parameter_missing
      raise ActionController::ParameterMissing.new('address')
    end

    def authenticity_token
      raise ActionController::InvalidAuthenticityToken.new('Invalid authenticity token')
    end

    def unknown_format
      raise ActionController::UnknownFormat.new('Unknown format')
    end
  end

  describe 'rescue_from StandardError' do
    it 'renders internal server error' do
      get :index
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe 'rescue_from ActionController::ParameterMissing' do
    it 'renders unprocessable entity' do
      routes.draw { get 'parameter_missing' => 'anonymous#parameter_missing' }

      get :parameter_missing
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'rescue_from ActionController::InvalidAuthenticityToken' do
    it 'raises exception and does not rescue' do
      routes.draw { get 'authenticity_token' => 'anonymous#authenticity_token' }

      expect { get :authenticity_token }.to raise_error(ActionController::InvalidAuthenticityToken)
    end
  end

  describe 'rescue_from ActionController::UnknownFormat' do
    it 'renders not acceptable' do
      routes.draw { get 'unknown_format' => 'anonymous#unknown_format' }

      get :unknown_format
      expect(response).to have_http_status(:not_acceptable)
    end
  end
end
