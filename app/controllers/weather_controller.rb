# frozen_string_literal: true

# Weather Controller
class WeatherController < ApplicationController
  def fetch
    @weather = WeatherDetailsService.new(permitted_params).call

    render :index
  end

  private

  def permitted_params
    params.require(:address)
  end
end
