#!/bin/sh

git push
git push heroku/master
heroku run rake db:migrate
