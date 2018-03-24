class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

  private

  def authenticate
    @logined = authenticated?
    return if @logined

    redirect_to main_login_path
  end

  def authenticated?
    @token_set = session[:access_token_set]
    return false if @token_set.nil?
    true
  end
end
