echo "Precompile Assets"
rake assets:precompile
git add .
git commit -m "precompile"

echo "Push to Github"
git push github master

echo "Push to Heroku"
git push heroku master

echo "Database Migration"
heroku run rake db:migrate
