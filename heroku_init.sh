#!/bin/sh

heroku create
rake assets:precompile
git add .
git commit -m "Add precompiled assets for Heroku"
git push heroku master
heroku run rake db:migrate
