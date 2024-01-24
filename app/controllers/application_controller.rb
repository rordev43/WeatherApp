class ApplicationController < ActionController::Base
  include Rescuable

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
