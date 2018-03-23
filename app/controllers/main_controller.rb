# frozen_string_literal: true

# Auths-demo app Main controller
class MainController < ApplicationController
  skip_before_action :authenticate, only: %i[index login]

  def index
    @logined = authenticated?
  end

  def show
    redirect_to @token_set['redirect']
  end

  def login; end

  def logout
    session.delete(:access_token_set)
    redirect_to main_index_path
  end
end
