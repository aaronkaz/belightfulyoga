# Load the rails application
require File.expand_path('../application', __FILE__)

heroku_env = File.join(Rails.root, 'config', 'heroku_env.rb')
load(heroku_env) if File.exists?(heroku_env) && Rails.env == 'development'

# Initialize the rails application
Belightfulyoga::Application.initialize!
