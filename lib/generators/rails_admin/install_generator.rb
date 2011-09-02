require 'rails/generators'
require File.expand_path('../utils', __FILE__)

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

# TODO
# make initializer more user friendly, add commented default configuration (cancan, included, excluded, etc.)
# if initializer exists, write to rails_admin.rb.timestamp.example with a notice instead of proposing to overwrite
# provide a quick link for a rails application with rails_admin in the readme

module RailsAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods
    
    argument :_model_name, :type => :string, :required => false, :desc => "Devise user model name"
    argument :_namespace, :type => :string, :required => false, :desc => "RailsAdmin url namespace"
    desc "RailsAdmin installation generator"

    def installation
      display "Hello! RailsAdmin works with Devise, let's look at a few things first:"
      display "Checking for a current installation of devise..."
      unless defined?(Devise)
        display "Adding devise gem to your Gemfile:"
        gem 'devise'
      else
        display "Found it!"
      end
      
      unless File.exists?(Rails.root.join("config/initializers/devise.rb"))
        display "Looks like you don't have devise installed! We'll install it for you:"
        generate "devise:install"
      else
        display "Looks like you've already installed it, good!"
      end
      
      routes = File.open(Rails.root.join("config/routes.rb")).read
      unless routes.index("devise_for")
        model_name = ask_for("What would you like the user model to be called?", "user", _model_name)
        display "Now setting up devise with user model name '#{model_name}':"
        generate "devise", model_name
      else
        display "And you already set it up, good! We just need to know about your user model name..."
        guess = routes.match(/devise_for :(.+)/)[1].singularize
        display("We found '#{guess}' (should be one of 'user', 'admin', etc.)")
        model_name = ask_for("Correct Devise model name if needed.", guess, _model_name)
      end
            
      display "Now you'll need an initializer, a migration and a namespaced route! Let's generate those!"
      initializer("rails_admin.rb") do <<-BLOCK.strip_heredoc
          RailsAdmin.config do |config|
            config.current_user_method do
              current_#{model_name}
            end
          end
        BLOCK
      end
      migration_template 'migration.rb', 'db/migrate/create_rails_admin_histories_table.rb' rescue p $!.message
      
      namespace = ask_for("Where will you want to mount rails_admin?", "admin", _namespace)
      gsub_file Rails.root.join("config/routes.rb"), /mount RailsAdmin::Engine => \'\/.+\', :as => \'rails_admin\'/, ''
      route("mount RailsAdmin::Engine => '/#{namespace}', :as => 'rails_admin'")
      display "Job's done, migrate, start your server and visit '/#{namespace}'!", :red
    end
  end
end
