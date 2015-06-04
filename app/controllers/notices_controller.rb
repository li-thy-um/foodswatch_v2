class NoticesController < ApplicationController
  before_action :signed_in_user

  def count
  end

  def index
    @notices = current_user.notices.paginate(page: params[:page])
    @notices.each do |notice|
      notice.update_attribute(:read, true) unless notice.read
    end
  end
end
