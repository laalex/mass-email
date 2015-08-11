# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'mailer'
set :scm, :git
set :repo_url, 'git@github.com:laalex/mass-email.git'

# Define where to put your application code
set :deploy_to, "/home/deploy/mailer"

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :passenger_environment_variables, { :path => '/usr/bin/passenger:$PATH' }


set :pty, false
set :format, :pretty

# This is the standard Phusion Passenger restart code.
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :reset_database do
    run_remote_rake "db:reset"
  end
end



after "deploy:restart", "deploy:cleanup"
