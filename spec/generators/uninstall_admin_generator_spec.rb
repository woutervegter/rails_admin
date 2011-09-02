require 'spec_helper'

describe 'RailsAdmin::UninstallMigrationsGenerator' do
  context "with no arguments" do
    include GeneratorSpec::TestCase

    destination File.expand_path("../tmp", __FILE__)
    tests RailsAdmin::UninstallMigrationsGenerator

    it "creates migrations" do
      prepare_destination
      
      # Before
      assert_no_migration 'db/migrate/drop_rails_admin_histories.rb'
      
      run_generator
      
      # After
      assert_migration 'db/migrate/drop_rails_admin_histories.rb'
    end
  end
end
