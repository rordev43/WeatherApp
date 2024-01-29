# WeatherAPP

WeatherAPP is a simple web application that provides weather information based on user-selected locations. It utilizes the OpenWeatherMap API for weather data and Geocodio for geocoding location information.

## Setup

### Ruby 3.3.0
### Rails 7.1.2
### Obtain API Keys

Before running the WeatherAPP, you need to sign up for accounts on OpenWeatherMap and Geocodio to obtain the necessary API keys.

1. **OpenWeatherMap API Key:**
   - Visit [OpenWeatherMap](https://openweathermap.org/) and sign up for a free account.
   - Once registered, obtain your API key from the account dashboard.

2. **Geocodio API Key:**
   - Visit [Geocodio](https://www.geocod.io/) and sign up for an account.
   - After registration, locate your API key in your account settings.

### Setup Environment Variables

Create a `.env` file in the project root directory and set the following environment variables:

```dotenv
GEOCODIO_API_KEY= 'YOUR_GEOCODIO_API_KEY'
OPEN_WEATHER_API_KEY= 'YOUR_OPEN_WEATHER_API_KEY'
REDIS_PORT= 'YOUR_REDIS_PORT'
REDIS_HOST= 'YOUR_REDIS_HOST'
REDIS_DB= 'YOUR_REDIS_DB'
```

Replace 'YOUR_GEOCODIO_API_KEY' and 'YOUR_OPEN_WEATHER_API_KEY' with the API keys obtained from Geocodio and OpenWeatherMap, respectively. Set the Redis related variables according to your Redis setup.

### Rails Essential Commands

To run the WeatherAPP locally, follow these essential Rails commands:

#### Install dependencies:

```bash
bundle install
```

#### Run database migrations:

```bash
rails db:setup
```

#### Start the Rails server:

```bash
rails server
```

Visit http://localhost:3000 in your web browser to access the WeatherAPP.
