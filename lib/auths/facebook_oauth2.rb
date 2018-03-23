module Auths
  # Operator for Facebook Oauth2
  class FacebookOauth2 < Authorize
    attr_accessor :state, :code
    attr_reader :access_token, :user_id
    attr_reader :user_profile

    def authorization_endpoint_uri
      host = fconf['auth_endpoint_host']
      path = fconf['auth_endpoint_path']
      query = query_for_authorization
      "#{host}#{path}?#{query}"
    end

    def obtain_access_token
      res = get_endpoint(fconf['token_endpoint_host'],
                         fconf['token_endpoint_path'],
                         nil,
                         query_for_token_endpoint)
      return parse_access_token res.body if res.status == 200

      raise(Auths::Error::Unauthorized,
            "error on obtaining access token: #{res.status}")
    end

    def debug_access_token
      res = get_endpoint(fconf['token_endpoint_host'],
                         fconf['token_debug_path'],
                         nil,
                         query_for_token_debug)
      if res.status == 200
        parse_token_debug res.body
        validate_token_debug
        return
      end

      raise Auths::Error::Unauthorized, "error on token debug: #{res.status}"
    end

    def obtain_user_profile
      res = get_endpoint(fconf['userinfo_endpoint_host'],
                         "/#{@user_id}",
                         @access_token,
                         query_for_userinfo_endpoint)
      return parse_user_profile res.body if res.status == 200

      raise(Auths::Error::Unauthorized,
            "error on obtaining user data: #{res.status}")
    end

    private

    def query_for_authorization
      hash2qstr(
        client_id: fconf['app_id'],
        response_type: 'code',
        scope: 'email public_profile',
        redirect_uri: fconf['redirect_uri'],
        state: @state
      )
    end

    def query_for_token_endpoint
      {
        code: @code,
        client_id: fconf['app_id'],
        client_secret: fconf['app_secret'],
        redirect_uri: fconf['redirect_uri']
      }
    end

    def parse_access_token(body)
      hash = JSON.parse(body)
      @access_token = hash['access_token']
      @token_type = hash['token_type']
      @expires_in = hash['expires_in']

      puts "token_type = #{@token_type}"
      puts "expires_in = #{@expires_in}"

    end

    def query_for_token_debug
      {
        input_token: @access_token,
        access_token: "#{fconf['app_id']}|#{fconf['app_secret']}"
      }
    end

    def parse_token_debug(body)
      hash = JSON.parse(body)['data']
      @app_id = hash['app_id']
      @user_id = hash['user_id']
    end

    def validate_token_debug
      return if @app_id.to_s == fconf['app_id'].to_s
      raise(Auths::Error::Unauthorized, 'access_token has wrong app_id')
    end

    def query_for_userinfo_endpoint
      { fields: 'id,first_name,name,picture,email' }
    end

    def parse_user_profile(body)
      @user_profile = JSON.parse(body)
    end
  end
end
