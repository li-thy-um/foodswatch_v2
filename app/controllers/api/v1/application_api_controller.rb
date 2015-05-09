class Api::V1::ApplicationApiController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid, with: :render_error_messages

  private

    def render_error_messages(exception)
      render_error exception.record.messages
    end

    def authorize_user
      @user = User.find_by remember_token: params[:auth_token]
      render_error("验证失败") if @user.nil?
    end

    def render_success
      render json: {success: true}
    end

    def render_error(obj)
      render json: {success: false, data: obj}
    end

    def render_json(obj)
      render json: {success: true, data: obj}
    end
end
