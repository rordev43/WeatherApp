# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  # Concern to rescue some possible exceptions
  include Rescuable

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
