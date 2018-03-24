# frozen_string_literal: true

module Rp
  # OAuth Client for Twitter
  class FacebookController < Rp::AppController
    before_action :rp

    PROVIDER = 'facebook'

    def index
      initialize_rp_for_index
      store_state

      # STEP1. Request to authorization_endpoint
      redirect_to @rp.authorization_endpoint_uri
    end

    def create
      validate_params_on_create
      load_state
      verify_state
      initialize_rp_on_create

      # STEP2. Exchange code to access_token
      @provider.obtain_access_token

      store_access_token
      redirect_to main_index_path
    end

    def show
    end

    private

    def rp
      super PROVIDER
    end

    def initialize_rp_for_index
      @provider.state = gen_state

      # TODO: debug
      puts("state = #{@rp.state}")
    end

    def store_state
      # You should store them to your database.
      # This is just a demo.
      session[:state_set] = { 'state' => @rp.state }
    end

    def validate_params_on_create
      raise 'Missing parameter state' if params[:state].nil?
      raise 'Missing parameter code' if params[:code].nil?
    end

    def load_state
      # You should load them from your database.
      # This is just a demo.
      @state = session[:state_set]
      raise 'Missing state_set' if @state.nil?
      raise 'Missing state' if @state['state'].nil?
      session[:state_set] = nil
    end

    def verify_state
      raise 'state is invalid' unless params['state'] == @state['state']
    end

    def initialize_rp_for_create
      @provider.state = params['state']
      @provider.state = params['code']

      # TODO: debug
      puts("state = #{@rp.state}")
      puts("code = #{@rp.code}")
    end

    def store_access_token
      # You should store them to your database.
      # This is just a demo.
      session[:access_token_set] = {
        'token' => @rp.access_token,
        'redirect' => '/rp/facebook/show'
      }
    end

    def load_access_token
      # You should load them from your database.
      # This is just a demo.
      @token = session[:access_token_set]
      raise 'Missing access_token_set' if @token.nil?
      raise 'Missing access_token' if @token['token'].nil?
    end
  end
end
