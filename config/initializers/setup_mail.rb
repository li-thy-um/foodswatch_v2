ActionMailer::Base.smtp_settings = {
  :address              => 'smtp.gmail.com',
  :port                 => 587,
  :domain               => 'gmail.com',
  :user_name            => 'lifeng4010@gmail.com',
  :password             => 'qpzmfj4010',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}
