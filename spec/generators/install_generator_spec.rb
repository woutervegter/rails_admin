require 'spec_helper'



describe 'RailsAdmin::InstallGenerator' do
  context "when called" do
    include GeneratorSpec::TestCase
    destination File.expand_path("../tmp/dummy_app", __FILE__)
    tests RailsAdmin::InstallGenerator

    it "creates migrations" do
      prepare_destination
      @rails_root = Rails.configuration.root
      Rails.configuration.root = Pathname.new(destination_root)

      FileUtils.cp_r(::File.expand_path("../../dummy_app/", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      FileUtils.rm(::File.expand_path("config/initializers/rails_admin.rb", Pathname.new(destination_root)))
      # Before
      assert_no_migration 'db/migrate/create_rails_admin_histories_table.rb'
      assert_no_file 'config/initializers/rails_admin.rb'
      
      run_generator ['admin', 'rails_admin_root']

      # After
      assert_migration 'db/migrate/create_rails_admin_histories_table.rb'
      # Todo, pseudo-code (meanwhile we can check visually inside the test/dummmy_app directory :D )
      #      assert_gem 'devise'
      #      assert_gem 'rails_admin'
      #      assert_route 'devise_for :admins'
      #      assert_route 'mount RailsAdmin::Engine => \'/rails_admin_root\', :as => \'rails_admin\''
      assert_file 'config/initializers/rails_admin.rb'
      
      Rails.configuration.root = @rails_root
    end

  end
end
