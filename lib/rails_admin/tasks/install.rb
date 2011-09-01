require 'rails/generators'

module RailsAdmin
  module Tasks
    class Install
      def self.run(model_name = 'user')
        puts "Hello! First of all, Rails_admin works with devise."
        puts "Checking for a current installation of devise!"
        unless defined?(Devise)
          puts "Please put gem 'devise' into your Gemfile and relaunch this task again"
          # todo gem 'devise'
        else
          puts "Found it!"
        end
        devise_path = Rails.root.join("config/initializers/devise.rb")
        unless File.exists?(devise_path)
          puts "Looks like you don't have devise installed! We'll install it for you!"
          `rails g devise:install`
        else
          puts "Looks like you already installed it, good!"
        end
        routes_path = Rails.root.join("config/routes.rb")
        content = ""
        File.readlines(routes_path).each{|line| content += line }
        unless content.index("devise_for")
          puts "Now setting up devise for you!"
          `rails g devise #{model_name}`
        else
          
        end
        puts "Also you'll need a new migration, an initializer and a new route! Let's generate those!"
        `rails g rails_admin:install_migrations`
      end
    end
  end
end
