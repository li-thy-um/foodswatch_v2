module User::Avatar

  # 存储空间
  QINIU_BUKET = "foodswatch"

  # 七牛上传地址，这里不能使用https，否则卡超时
  QINIU_UPLOAD_URL = "http://upload.qiniu.com/"

  # 七牛下载地址
  QINIU_DOWNLOAD_URL = "http://7xj46v.com1.z0.glb.clouddn.com/"

  def upload_avatar(uploaded_io)
    put_policy = Qiniu::Auth::PutPolicy.new(
      QINIU_BUKET,     # 存储空间
      file_name        # 最终资源名，可省略
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    post_data = {
      file: uploaded_io,
      token: uptoken,
      key: file_name
    }

    ### 发送请求
    response = RestClient.post(QINIU_UPLOAD_URL, post_data)

    raise "Avatar Upload Post request fail, post_data: #{post_data.inspect}. response: #{response.inspect}" unless response.code == 200
    self.update_attribute :avatar, file_name
  end

  # 暂时没有使用
  def update_avatar!
    return if avatar == file_name
    update_avatar_file
    self.update_attribute :avatar, file_name
  end

  def remove_avatar!
    return if avatar.nil?
    remove_avatar_file
    update_attribute :avatar, nil
  end

  def remove_avatar_file

    code, result, response_headers = Qiniu::Storage.delete(
      QINIU_BUKET, # 存储空间
      file_name    # 资源名
    )

    raise "Avatar Delete Post request fail, result: #{result}" unless code == 200
  end

  # 暂时没有使用
  def update_avatar_file
    code, result, response_headers = Qiniu::Storage.move(
      QINIU_BUKET, # 源存储空间
      avatar,      # 源资源名
      QINIU_BUKET, # 目标存储空间
      file_name    # 目标资源名
    )

    raise "Avatar Move Post request fail, result: #{result}" unless code == 200
  end

  def avatar_url
    avatar && "#{QINIU_DOWNLOAD_URL}#{file_name}"
  end

  private

  def file_name
    "#{self.email}.png"
  end
end
