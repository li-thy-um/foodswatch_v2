echo "1.PUSH TO HEROKU"
git push heroku master
echo "2.DB MIGRATION"
heroku run rake db:migrate
echo "3.ASSETS PRECOMPILE"
heroku run rake assets:precompile
