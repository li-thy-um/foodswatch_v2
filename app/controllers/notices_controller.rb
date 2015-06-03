class NoticesController < ApplicationController
  before_action :signed_in_user
  
  def count
  end

  def index
    @notices = current_user.notices.paginate(page: params[:page])
  end

  def update
    Notice.find_by_id(params[:id]).update! read: true
    head 200, content_type: "text/html"
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    head 500, content_type: "text/html"
  end
end
