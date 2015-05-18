module User::Avatar

  # 存储空间
  QINIU_BUKET = {
    development: "foodswatch-dev",
    production: "foodswatch"
  }[Rails.env.to_sym]

  # 七牛上传地址，这里不能使用https，否则卡超时
  QINIU_UPLOAD_URL = "http://upload.qiniu.com/"

  # 七牛下载地址
  QINIU_DOWNLOAD_URL = {
    development: "http://7xj47s.com1.z0.glb.clouddn.com/",
    production: "http://7xj46v.com1.z0.glb.clouddn.com/"
  }[Rails.env.to_sym]

  # 头像文件大小最大值
  MAX_AVATAR_SIZE = 2_000_000 # 字节

  # 上传头像
  def upload_avatar(avatar_file)
    validate_file_size avatar_file
    file_name = next_file_name
    put_policy = Qiniu::Auth::PutPolicy.new(
      QINIU_BUKET,     # 存储空间
      file_name        # 最终资源名，可省略
    )
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    post_data = {
      file: avatar_file,
      token: uptoken,
      key: file_name
    }
    ### 发送请求
    response = RestClient.post(QINIU_UPLOAD_URL, post_data)
    unless response.code == 200
      raise "Avatar Upload Post request fail, post_data: #{post_data.inspect}. response: #{response.inspect}"
    end
    remove_avatar_file! if avatar?
    self.update_attribute :avatar, file_name
  end

  def remove_avatar!
    return unless avatar?
    remove_avatar_file!
    update_attribute :avatar, nil
  end

  def remove_avatar_file!
    code, result, response_headers = Qiniu::Storage.delete(
      QINIU_BUKET, # 存储空间
      avatar    # 资源名
    )
    raise "Avatar Delete Post request fail, result: #{result}" unless code == 200
  end

  def avatar_url
    avatar && "#{QINIU_DOWNLOAD_URL}#{avatar}"
  end

  private

  def validate_file_size(avatar_file)
    if avatar_file.size > MAX_AVATAR_SIZE
      raise "Avatar File Too Big, file_size: #{avatar_file.size}, max_size: #{MAX_AVATAR_SIZE}"
    end
  end

  def next_file_name
    if avatar.nil?
      "0_#{self.email}.png"
    else
      num = avatar.split('_').first.to_i + 1
      "#{num}_#{self.email}.png"
    end
  end
end
