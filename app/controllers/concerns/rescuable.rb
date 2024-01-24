# frozen_string_literal: true

# Module: Rescuable
# Purpose: To rescue some possible errors
module Rescuable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError,                              with: :render_internal_error
    rescue_from ActionController::ParameterMissing,         with: :render_parameter_missing
    rescue_from ActionController::InvalidAuthenticityToken, with: :dont_rescue_authenticity_token
    rescue_from ActionController::UnknownFormat,            with: :render_unknown_format
  end

  def render_unknown_format(exception)
    return if performed?

    @message = exception.message
    render 'errors/error', status: :not_acceptable
  end

  def render_parameter_missing(exception)
    return if performed?

    @message = exception.message
    render 'errors/error', status: :unprocessable_entity
  end

  def dont_rescue_authenticity_token(exception)
    raise exception
  end

  def render_internal_error(exception)
    return if performed?

    @message = exception.message
    render 'errors/error', status: :internal_server_error
  end
end
