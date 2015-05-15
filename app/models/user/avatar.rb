module User::Avatar

  def upload_avatar(uploaded_io)

    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    self.update_attribute :avatar, file_name
  end

  def update_avatar!
    return if avatar == file_name
    File.rename file_path(avatar), file_path
    self.update_attribute :avatar, file_name
  end

  def remove_avatar!
    return if avatar.nil?
    update_attribute :avatar, nil
    remove_avatar_file
  end

  def remove_avatar_file
    File.delete file_path
  end

  def avatar_url
    avatar && "/avatars/#{file_name}"
  end

  private

  def file_name
    "#{self.email}.png"
  end

  def file_path(name = file_name)
    Rails.root.join('public', 'avatars', name)
  end
end
