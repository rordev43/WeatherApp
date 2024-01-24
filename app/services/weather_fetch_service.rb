class WeatherFetchService < ApplicationService
  attr_reader :parsed_address

  def initialize(address)
    @parsed_address = AddressParsingService.new(address).call
    @conn = Faraday.new('https://api.openweathermap.org/data/2.5/weather')
  end

  def call
    response = request(request_params({ 'lat': parsed_address.latitude, 'lon': parsed_address.longitude }))

    unless response.status == 200
      response = request(request_params({ 'q': "#{parsed_address.city}, #{parsed_address.state}, US" }))
    end

    JSON.parse(response.body)
  end

  private

  def request_params(params)
    { 'units': 'metric', 'appid': ENV['OPEN_WEATHER_API_KEY'] }.merge(params)
  end

  def request(params)
    @conn.get do |req|
      req.params = params
    end
  end
end
