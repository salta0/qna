# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'qna'
set :repo_url, 'git@github.com:saltukhova/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/qna"
set :deploy_user, 'deploy'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', 'config/thinking_sphinx.yml', '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

set :private_pub_pid, -> { "#{current_path}/tmp/pids/thin.pid" }

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      invoke 'private_pub:stop'
      invoke 'private_pub:start'
    end
  end
end

after 'deploy:restart', 'private_pub:restart'


namespace :ts do
  task :conf do
    thinking_sphinx.configure
  end
  task :in do
    thinking_sphinx.index
  end
  task :start do
    thinking_sphinx.start
  end
  task :stop do
    thinking_sphinx.stop
  end
  task :restart do
    thinking_sphinx.restart
  end
  task :rebuild do
    thinking_sphinx.rebuild
  end
end
