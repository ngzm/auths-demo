module Auths
  # Operator for Twitter Oauth
  class TwitterOauth < Authorize
    attr_accessor :request_token, :request_token_secret
    attr_accessor :oauth_token, :oauth_verifier
    attr_accessor :access_token, :access_token_secret, :user_id, :screen_name
    attr_reader :user_profile

    def obtain_request_token
      res = post_endpoint(tconf['request_endpoint_host'],
                          tconf['request_endpoint_path'],
                          options_for_request_endpoint)
      return parse_request_token res.body if res.status == 200

      raise(Auths::Error::Unauthorized,
            "error on obtaining request token: #{res.status}")
    end

    def authorization_endpoint_uri
      query = "oauth_token=#{@request_token}"
      host = tconf['auth_endpoint_host']
      path = tconf['auth_endpoint_path']
      "#{host}#{path}?#{query}"
    end

    def obtain_access_token
      res = post_endpoint(tconf['token_endpoint_host'],
                          tconf['token_endpoint_path'],
                          options_for_token_endpoint)
      return parse_access_token res.body if res.status == 200

      raise(Auths::Error::Unauthorized,
            "error on obtaining access token: #{res.status}")
    end

    def obtain_user_profile
      res = get_endpoint(tconf['user_endpoint_host'],
                         tconf['user_endpoint_path'],
                         options_for_user_endpoint,
                         query_for_user_endpoint)
      return parse_user_data res.body if res.status == 200

      raise(Auths::Error::Unauthorized,
            "error on obtaining user data: #{res.status}")
    end

    private

    # Overwrite
    # This is for OAuth1.0
    def setup_http_connection(host, opt)
      conn = Faraday.new(url: host) do |client|
        client.request :url_encoded
        client.request :oauth, opt
        client.adapter Faraday.default_adapter
      end
      conn
    end

    def options_for_request_endpoint
      {
        consumer_key: tconf['consumer_key'],
        consumer_secret: tconf['consumer_secret'],
        callback: tconf['callback_url']
      }
    end

    def parse_request_token(body)
      hash = qstr2hash(body)
      @request_token = hash[:oauth_token]
      @request_token_secret = hash[:oauth_token_secret]
    end

    def options_for_token_endpoint
      {
        consumer_key: tconf['consumer_key'],
        consumer_secret: tconf['consumer_secret'],
        token: @oauth_token,
        token_secret: @request_token_secret,
        verifier: @oauth_verifier
      }
    end

    def parse_access_token(body)
      hash = qstr2hash(body)
      @access_token = hash[:oauth_token]
      @access_token_secret = hash[:oauth_token_secret]
      @user_id = hash[:user_id]
      @screen_name = hash[:screen_name]
      @x_auth_expires = hash[:s_auth_expires]
    end

    def options_for_user_endpoint
      {
        consumer_key: tconf['consumer_key'],
        consumer_secret: tconf['consumer_secret'],
        token: @access_token,
        token_secret: @access_token_secret
      }
    end

    def query_for_user_endpoint
      { user_id: @user_id }
    end

    def parse_user_data(body)
      @user_profile = JSON.parse(body)
    end
  end
end
