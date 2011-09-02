require File.expand_path('../../rails_admin/tasks/install', __FILE__)

namespace :rails_admin do
  desc "Install rails_admin"
  task :install do
    puts "Running rails_admin install generator!"
    `rails g rails_admin:install #{ENV['model_name'] || 'user'}`
  end
end