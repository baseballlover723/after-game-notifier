# config/puma.rb
workers Integer(ENV['WEB_CONCURRENCY'] || 2) if Rails.env.production?
threads_count = Integer(ENV['MAX_THREADS'] || 8)
Rails.env.production? ? threads(threads_count, threads_count) : threads(0 , threads_count)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end