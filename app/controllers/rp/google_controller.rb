# frozen_string_literal: true

module Rp
  # OAuth Client for Twitter
  class GoogleController < Rp::AppController
    skip_before_action :authenticate, only: %i[index create]
    before_action :rp

    PROVIDER = 'google'

    def index
      initialize_rp_on_index
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
      @rp.obtain_access_token

      # STEP3. Validate id_token and authenticate the user
      @rp.validate_id_token

      store_access_token
      redirect_to main_index_path
    end

    def show
      load_access_token
      initialize_rp_on_show

      # STEP4. Obtaining user profile information
      @rp.obtain_user_profile
      @profile = @rp.user_profile
    end

    private

    def rp
      super PROVIDER
    end

    def initialize_rp_on_index
      @rp.state = authorization_state
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
      @state_set = session[:state_set]
      raise 'Missing state_set' if @state_set.nil?
      raise 'Missing state' if @state_set['state'].nil?
      session[:state_set] = nil
    end

    def verify_state
      raise 'state is invalid' unless params[:state] == @state_set['state']
    end

    def initialize_rp_on_create
      @rp.state = params[:state]
      @rp.code = params[:code]
    end

    def store_access_token
      # You should store them to your database.
      # This is just a demo.
      session[:access_token_set] = {
        'token' => @rp.access_token,
        'id_token' => @rp.id_token,
        'redirect' => '/rp/google/show',
        'provider' => PROVIDER
      }
    end

    def load_access_token
      # You should load them from your database.
      # This is just a demo.
      @token_set = session[:access_token_set]
      raise 'Missing access_token_set' if @token_set.nil?
      raise 'Missing access_token' if @token_set['token'].nil?
      raise 'Missing id_token' if @token_set['id_token'].nil?
    end

    def initialize_rp_on_show
      @rp.access_token = @token_set['token']
      @rp.id_token = @token_set['id_token']
    end
  end
end
