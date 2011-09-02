require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module RailsAdmin
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)
    desc "RailsAdmin full installation generator"

    def installation
      # http://guides.rubyonrails.org/generators.html
      # http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
      model_name = file_name
      
      say "Hello! First of all, Rails_admin works with devise."
      
      say "Checking for a current installation of devise!"
      unless defined?(Devise)
        say "Adding devise gem to your Gemfile"
        gem 'devise'
      else
        say "Found it!"
      end
      devise_path = Rails.root.join("config/initializers/devise.rb")
      unless File.exists?(devise_path)
        say "Looks like you don't have devise installed! We'll install it for you!"
        run "rails g devise:install"
      else
        say "Looks like you already installed it, good!"
      end
      unless File.open(Rails.root.join("config/routes.rb")).read.index("devise_for")
        say "Now setting up devise for you!"
        run "rails g devise #{model_name}"
      else
        say "And you already set it up, good!"
      end
      say "Now you'll need a new migration, an initializer and a new route! Let's generate those!"
      
      # TODO make it user friendly, add commented default configuration (cancan, included, excluded, etc.)
      initializer("rails_admin.rb") do <<-BLOCK
RailsAdmin.config do |config|
  config.current_user_method do
    current_#{model_name}
  end
end
BLOCK
      end
      route("mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'")
      
      puts "Installing migrations !"
      run "rails g rails_admin:install_migrations"
    end
  end
end
