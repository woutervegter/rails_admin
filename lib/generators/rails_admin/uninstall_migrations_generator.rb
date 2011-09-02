require 'rails/generators'
require 'rails/generators/migration'
require File.expand_path('../utils', __FILE__)

module RailsAdmin
  class UninstallMigrationsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods
    source_root File.expand_path('../templates', __FILE__)

    desc "RailsAdmin uninstall"

    def create_migration_file
      migration_template 'drop.rb', 'db/migrate/drop_rails_admin_histories.rb'
    end
  end
end
