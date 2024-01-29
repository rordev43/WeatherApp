# frozen_string_literal: true

# Weather Fetch Service
# Purpose: Fetch the weather by address using openweathermap service
class WeatherDetailsService < ApplicationService
  attr_reader :parsed_address, :conn

  OPEN_WEATHER_HOST_URL = 'https://api.openweathermap.org/data/2.5/weather'

  def initialize(address)
    super()
    @parsed_address = AddressParsingService.new(address).call
    @conn = Faraday.new(OPEN_WEATHER_HOST_URL)
  end

  def call
    response = cached_value
    return response if response.present?

    cache(weather_from_api)
  end

  private

  def request_params(params)
    { units: 'metric', appid: ENV.fetch('OPEN_WEATHER_API_KEY', nil) }.merge(params)
  end

  def request(params)
    conn.get do |req|
      req.params = params
    end
  end

  def cached_value
    response = $redis.get(parsed_address.zip)
    unless response.nil?
      response = JSON.parse(response)
      response['is_cached'] = true
    end

    response
  end

  def cache(response)
    $redis.setex(parsed_address.zip, 30.minutes.to_i, response)
    response = JSON.parse(response)
    response['is_cached'] = false

    response
  end

  def weather_from_api
    response = request(request_params({ lat: parsed_address.latitude, lon: parsed_address.longitude }))

    unless response.status == 200
      response = request(request_params({ q: "#{parsed_address.city}, #{parsed_address.state}, US" }))
    end

    raise StandardError, "There's an issue with fetching weather service right now." if response.status != 200

    response.body
  end
end
