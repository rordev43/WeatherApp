module Rescuable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError,                              with: :render_internal_error
    rescue_from ActionController::ParameterMissing,         with: :render_parameter_missing
    rescue_from ActionController::InvalidAuthenticityToken, with: :dont_rescue_authenticity_token
    rescue_from ActionController::UnknownFormat,            with: :render_unknown_format
  end

  def render_unknown_format(_exception)
    return if performed?

    render file: Rails.public_path.join('406.html'), layout: false, status: :not_acceptable
  end

  def render_parameter_missing(exception)
    return if performed?

    @message = if exception.errors.respond_to?(:to_h)
                 exception.errors.map do |k, v|
                   "#{k}: #{v.join(', ')}"
                 end.join("\n")
               else
                 exception.errors
               end
    render file: Rails.public_path.join('422.html'), layout: false, status: :unprocessable_entity
  end

  def dont_rescue_authenticity_token(exception)
    raise exception
  end

  def render_internal_error(_exception)
    return if performed?

    render file: Rails.public_path.join('500.html'), layout: false, status: :internal_server_error
  end
end
