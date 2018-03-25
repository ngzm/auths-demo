# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# run Rails.application

map ActionController::Base.relative_url_root || "/" do
  run Rails.application
end
