class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :prepare_foods, only: :create
  before_action :set_content, only: :create
  before_action :create_post_food, only: :create

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @post = Micropost.find_by_id(params[:parent_id])
    if @micropost.save
      handle_foods
      handle_message
      flash[:success] = "发布成功！"
      render action: params[:create_type]
    else
      render action: :create_fail
    end
  end

  def destroy
    if @micropost.original_id?
      action_type = :cancel_share
    else
      action_type = :destroy
    end
    @micropost.destroy
    render action: action_type
  end

  def comments
    @micropost = Micropost.find_by_id(params[:id])
    @comments = @micropost.comments.paginate(page: params[:page])
  end

  private

    def handle_message
      case params[:create_type]
      when :comment
        # TODO
      when :share

      end
    end

    def prepare_foods
      @foods = raw_list.map { |raw| cook(raw) }.compact
    end

    def cook(raw)
      raw.is_a?(String) ? Food.find_by_id(raw) : Food.new(raw)
    end

    def raw_list
      [params[:foods], params[:food_ids]].flatten.compact
    end

    def set_content
      trim_content
      return unless params[:micropost][:content] == ""
      if params[:micropost][:original_id] != nil
        params[:micropost][:content] = "我很懒什么都没说。。。"
        return
      end
      if @foods.any?
        params[:micropost][:content] = "我吃了:"
        return
      end
    end

    def trim_content
      params[:micropost][:content] = params[:micropost][:content].rstrip.lstrip
    end

    def create_post_food
      return if @foods.empty?
      info = {prot:0, carb:0, fat:0}
      @foods.each do |food|
        info[:prot] += food.prot
        info[:carb] += food.carb
        info[:fat] += food.fat
      end
      params[:micropost][:post_food_id] = Food.create(info).id
    end

    def handle_foods
      @foods.each do |food|
        food.save if food.id == nil
        # new food should add into watch list
        current_user.watch!(food) unless current_user.watching?(food)
        @micropost.attach!(food)
      end
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).
             permit(:content,     :comment_id,
                    :original_id, :shared_id, :post_food_id)
    end
end
