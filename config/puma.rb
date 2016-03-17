# config/puma.rb
threads 8,32
workers ENV["NUMB_WORKERS"] if Rails.env.production?
preload_app!