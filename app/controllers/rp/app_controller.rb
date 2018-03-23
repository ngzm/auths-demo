# frozen_string_literal: true

module Rp
  # Super class for RP or OAuth Client
  class AppController < ApplicationController
    rescue_from Auths::Error::AuthError, with: :handle_auth_error

    private

    def rp(provider)
      @rp = Auths::Authorize.rp(provider)
    end

    def authorization_state
      "auths_demo__#{SecureRandom.urlsafe_base64(32)}"
    end

    # Auth Error handler
    def handle_auth_error(err)
      logger.warn("AUTH ERROR: status: #{err.http_status}: #{err.message}")
      @errors = []
      @errors.push(
        level: err.error_level,
        message: err.message,
        status: err.http_status
      )
      render template: 'errors/auth', status: err.http_status
    end
  end
end
