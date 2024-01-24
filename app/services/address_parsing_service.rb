class AddressParsingService < ApplicationService
  attr_reader :address

  def initialize(address)
    @address = address
    @geocodio = Geocodio::Client.new(ENV['GEOCODIO_API_KEY'])
  end

  def call
    locations = @geocodio.geocode([address])

    locations.best
  end
end
