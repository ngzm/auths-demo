# frozen_string_literal: true

module Rp
  # OAuth Client for Twitter
  class TwitterController < Rp::AppController
    skip_before_action :authenticate, only: %i[index create]
    before_action :rp

    PROVIDER = 'twitter'

    def index
      # STEP1 request token
      @rp.obtain_request_token
      store_request_token

      # STEP2 authenticate token
      redirect_to @rp.authorization_endpoint_uri
    end

    def create
      validate_params_on_create
      load_request_token
      initialize_rp_on_create

      # STEP3 access token
      @rp.obtain_access_token

      store_access_token
      redirect_to main_index_path
    end

    def show
      load_access_token
      initialize_rp_on_show

      # STEP4 user profile data
      @rp.obtain_user_profile
      @profile = @rp.user_profile
    end

    private

    def rp
      super PROVIDER
    end

    def store_request_token
      # You should store them to your database.
      # This is just a demo.
      session[:request_token_set] = {
        'token' => @rp.request_token,
        'secret' => @rp.request_token_secret
      }
    end

    def validate_params_on_create
      raise 'Denied authorization' unless params[:denied].nil?
      raise 'Missing param oauth_token' if params[:oauth_token].nil?
      raise 'Missing param oauth_verifier' if params[:oauth_verifier].nil?
    end

    def load_request_token
      # You should load them from your database.
      # This is just a demo.
      @token_set = session[:request_token_set]
      raise 'Missing request_token_set' if @token_set.nil?
      raise 'Missing request_token' if @token_set['token'].nil?
      raise 'Missing request_token_secret' if @token_set['secret'].nil?
      session[:request_token_set] = nil
    end

    def initialize_rp_on_create
      @rp.oauth_token = params[:oauth_token]
      @rp.oauth_verifier = params[:oauth_verifier]
      @rp.request_token = @token_set['token']
      @rp.request_token_secret = @token_set['secret']
    end

    def store_access_token
      # You should store them to your database.
      # This is just a demo.
      session[:access_token_set] = {
        'token'   => @rp.access_token,
        'secret'  => @rp.access_token_secret,
        'user_id' => @rp.user_id,
        'redirect' => rp_twitter_show_url,
        'provider' => PROVIDER
      }
    end

    def load_access_token
      # You should load them from your database.
      # This is just a demo.
      @token_set = session[:access_token_set]
      raise 'Missing access_token_set' if @token_set.nil?
      raise 'Missing access_token' if @token_set['token'].nil?
      raise 'Missing access_token_secret' if @token_set['secret'].nil?
      raise 'Missing user_id' if @token_set['user_id'].nil?
    end

    def initialize_rp_on_show
      @rp.access_token = @token_set['token']
      @rp.access_token_secret = @token_set['secret']
      @rp.user_id = @token_set['user_id']
    end
  end
end
