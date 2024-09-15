# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks
namespace :dev do
  task :start do
    fork { exec "bin/rails server" }
    Process.waitall
  end
end