class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  after_action  :add_share_count, only: :create
  after_action  :minus_share_count, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
    
    def minus_share_count
      change_share_count(:minus)
    end
    
    def add_share_count
      change_share_count(:add)
    end

    def change_share_count (type)
      change_ids = Array.new
      change_ids << @micropost.original_id 
      change_ids << @micropost.shared_id
      change_ids.compact!
      return if change_ids.empty?
      Micropost.find(change_ids).each do |micropost|
        micropost.share_count = 0 if micropost.share_count == nil
        micropost.share_count += 1 if type == :add
        micropost.share_count -= 1 if type == :minus
        micropost.save
      end 
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).permit(:content,
                                        :comment_id,
                                        :original_id,
                                        :shared_id)
    end
end
