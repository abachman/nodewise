# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Nodewise::Application.load_tasks

task :prevent_production => :environment do 
  if Rails.env == 'production'
    raise StandardError.new("THIS TASK IS DESTRUCTIVE, DO NOT RUN IN PRODUCTION")
  end
end

desc "Wipe and reload seed data"
task :seed => [:prevent_production, "db:reset", "data:load"]
