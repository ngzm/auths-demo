module Auths
  # module for Google jwt tokens
  module GoogleJwtToken
    include Config

    def validate_jwt_token(token)
      payload = validate_jwt(token)
      validate_aud(payload)
      validate_iss(payload)
      validate_exp(payload)
    end

    def validate_jwt(token)
      validator = GoogleIDToken::Validator.new
      validator.check(token, gconf['client_id'])
    rescue GoogleIDToken::ValidationError => e
      raise Auths::Error::Unauthorized, "Invalid ID token: #{e}"
    end

    def validate_aud(payload)
      # aud must equal to client_id
      raise 'Invalid client id' unless payload['aud'] == gconf['client_id']
    end

    def validate_iss(payload)
      # iss must equal to issuer
      raise 'Invalid issuer' unless payload['iss'] == gconf['issuer']
    end

    def validate_exp(payload)
      # This ID token is not expired
      raise 'Already expired' if payload['exp'].to_i < Time.now.to_i
    end
  end
end
