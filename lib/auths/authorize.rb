module Auths
  # SuperClass of Authorization with Oauth1, Oauth2, Openid connect
  class Authorize
    include Config

    def self.rp(provider)
      if provider == 'google'
        GoogleOpenidConnect.new
      elsif provider == 'facebook'
        FacebookOauth2.new
      elsif provider == 'twitter'
        TwitterOauth.new
      else
        raise Auths::Error::AuthError "Unknown provider: #{provider}"
      end
    end

    def obtain_request_token; end

    def authorization_endpoint_uri; end

    def obtain_access_token; end

    def obtain_user_profile; end

    private

    def get_endpoint(host, path, opt, query = nil)
      conn = setup_http_connection(host, opt)
      if query.nil?
        conn.get path
      else
        conn.get path, query
      end
    end

    def post_endpoint(host, path, opt, body = nil)
      conn = setup_http_connection(host, opt)
      if body.nil?
        conn.post path
      else
        conn.post path, body
      end
    end

    def setup_http_connection(host, opt)
      # This is for OAuth2.0 or Openid Connect
      conn = Faraday.new(url: host) do |client|
        client.request :url_encoded
        client.request :oauth2, opt, token_type: 'bearer' unless opt.nil?
        client.adapter Faraday.default_adapter
      end
      conn
    end

    # hash to query string
    def hash2qstr(hash)
      qstr = ''
      hash.each do |k, v|
        qstr += '&' unless qstr.empty?
        qstr += "#{k}=#{v}"
      end
      qstr
    end

    # query string to hash
    def qstr2hash(qstr)
      hash = {}
      qstr.split('&').each do |hs|
        k, v = hs.split('=')
        k.nil? || v.nil? || hash[k.to_sym] = v.to_s
      end
      hash
    end
  end
end
