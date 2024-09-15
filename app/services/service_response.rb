# frozen_string_literal: true

class ServiceResponse
  def self.success(message: nil, payload: nil)
    new(status: :success, message: message, payload: payload)
  end

  def self.error(message: nil, payload: nil)
    new(status: :error, message: message, payload: payload)
  end

  attr_reader :status, :message, :payload

  def initialize(status:, message:, payload:)
    @status = status
    @message = message
    @payload = payload
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end

  delegate :[], to: :to_h

  def to_h
    (payload || {}).merge(
      status: status,
      message: message
    )
  end
end
