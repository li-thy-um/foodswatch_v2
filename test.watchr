watch( '.*\.rb' ) do
  system 'bundle exec rspec ./spec/'
end
