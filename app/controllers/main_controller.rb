# frozen_string_literal: true

# Auths-demo app Main controller
class MainController < ApplicationController
  before_action :authenticate, except: %i[index login]

  def index
    @logined = authenticated?
  end

  def show
    redirect_to @token['redirect']
  end

  def login; end

  def logout
    session.delete(:access_token_set)
    redirect_to main_index_path
  end

  private

  def authenticate
    @logined = authenticated?
    return if @logined

    redirect_to main_login_path
  end

  def authenticated?
    @token = session[:access_token_set]
    return false if @token.nil?
    true
  end
end
