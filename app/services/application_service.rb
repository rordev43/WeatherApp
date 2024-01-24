# frozen_string_literal: true

# Application Service
class ApplicationService
  def self.call(*, &)
    new(*, &).call
  end
end
