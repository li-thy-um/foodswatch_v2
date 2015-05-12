module User::Token

  def encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def random_token
    SecureRandom.urlsafe_base64
  end

  def encrypted_random_token
    encrypt(random_token)
  end

  alias :new_remember_token :random_token

end
