web: bundle exec puma
release: rake db:migrate db:seed
worker: RAILS_MAX_THREADS=10 bundle exec sidekiq -t 25 -q default -q mailers
