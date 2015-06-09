echo "Precompile Assets"
bundle exec rake assets:precompile RAILS_ENV=production

git add --all
git commit -m "precompile"

echo "Push to Github"
git push github master

echo "Push to Heroku"
git push heroku master

echo "Database Migration"
heroku run rake db:migrate --app foodswatch
