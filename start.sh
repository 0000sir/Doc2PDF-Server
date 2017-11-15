#! /bin/bash
if [ ! "$RAILS_ENV" = "production" ]
then
  bundle install
fi
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
rm tmp/pids/server.pid
bundle exec rails s -b 0.0.0.0 -p 3000
