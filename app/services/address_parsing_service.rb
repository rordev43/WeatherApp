# frozen_string_literal: true

# Address Parser Service
# Purpose: To parse a string to address using Geocodio service which will returns some extra information
# like longitude, latitude, etc.
class AddressParsingService < ApplicationService
  attr_reader :address

  def initialize(address)
    super
    @address = address
    @geocodio = Geocodio::Client.new(ENV.fetch('GEOCODIO_API_KEY', nil))
  end

  def call
    locations = @geocodio.geocode([address])

    locations.best
  end
end
