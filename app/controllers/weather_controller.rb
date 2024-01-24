class WeatherController < ApplicationController
  def weather
    @weather = WeatherFetchService.new(permited_params).call
    render :index
  end

  def permited_params
    params.require(:address)
  end
end
