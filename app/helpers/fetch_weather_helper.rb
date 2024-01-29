# frozen_string_literal: true

# FetchWeatherHelper
module FetchWeatherHelper
  def extract_weather_details(weather_data)
    return unless weather_data.present?

    weather_json(weather_data)
  end

  private

  def weather_json(weather_data)
    { 'name' => weather_data['name'],
      'is_cached' => weather_data['is_cached'],
      'icon' => weather_data.dig('weather', 0, 'icon'),
      'temp' => weather_data.dig('main', 'temp'),
      'feels_like' => weather_data.dig('main', 'feels_like'),
      'description' => weather_data.dig('weather', 0, 'description'),
      'humidity' => weather_data.dig('main', 'humidity'),
      'pressure' => weather_data.dig('main', 'pressure'),
      'visibility' => weather_data['visibility'] }
  end
end
