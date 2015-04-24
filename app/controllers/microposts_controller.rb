class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :prepare_foods, only: :create
  before_action :set_content, only: :create
  before_action :create_post_food, only: :create

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @post = Micropost.find_by_id(params[:parent_id]) #comment's parent
    if @micropost.save
      handle_foods
      render action: params[:create_type]
    else
      render action: :create_fail
    end
  end

  def destroy
    @micropost.destroy
    render action: :destroy
  end

  def comments
    @micropost = Micropost.find_by_id(params[:id])
    @comments = @micropost.comments.paginate(page: params[:page])
  end

  private

    def prepare_foods
      @foods = raw_list.map { |raw| cook(raw) }.compact
    end

    def cook(raw)
      if raw.is_a? String
        Food.find_by_id raw
      else
        if !raw[:name].nil?
          Food.new food_params(raw)
        end
      end
    end

    def raw_list
      [params[:foods], params[:food_ids]].flatten.compact
    end

    def set_content
      trim_content
      params[:micropost][:content] ||= case params[:create_type]
                                                                when 'create'
                                                                  @foods.any? ? '我吃了:' : ''
                                                                when 'share'
                                                                  '分享'
                                                                end
    end

    def trim_content
      content = params[:micropost][:content].strip
      params[:micropost][:content] = content == '' ? nil : content
    end

    def create_post_food
      return if @foods.empty?
      info = {prot:0, carb:0, fat:0}
      @foods.each do |food|
        info[:prot] += food.prot || 0
        info[:carb] += food.carb || 0
        info[:fat] += food.fat || 0
      end
      params[:micropost][:post_food_id] = Food.create(info).id
    end

    def handle_foods
      @foods.each do |food|
        food.save if food.id == nil
        # new food should be added into watch list
        current_user.watch!(food) unless current_user.watching?(food)
        @micropost.attach!(food)
      end
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def food_params(raw)
      raw.permit(:name, :carb, :prot, :fat)
    end

    def micropost_params
      params.require(:micropost).permit(:content, :comment_id, :original_id, :shared_id, :post_food_id)
    end
end
