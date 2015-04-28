class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :signed_in_user_can_not_new_or_create, only: [:new, :create]

  def calorie
    @user = User.find(params[:id])
    @title = "#{@user.name}的统计信息"
  end

  def watches
    @user = User.find(params[:id])
    @title = "#{@user.name}的食物"
    @foods = @user.watched_foods.paginate(page: params[:page])
    render 'watch_list'
  end

  def following
    @title = '关注'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = '粉丝'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users = User.order(created_at: :desc).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.where('comment_id is NULL').
      paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    user = User.find(params[:id])
    if user.admin && current_user?(user)
      flash[:error] = '管理员不能删除自己啦！'
      redirect_back_or(user)
    else
      user.destroy
      flash[:success] = '此人已死，有事烧纸！'
      redirect_to users_url
    end
  end

  def confirm_email
    @user = User.find(params[:id])
    @user && @user.confirm_email(params[:token])
    redirect_to signin_path
  rescue RuntimeError => e
    redirect_to signup_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      UserMailer.welcome_email(@user).deliver_later
      redirect_to @user
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = '身份信息已更新！'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    # Before filters

    def signed_in_user_can_not_new_or_create
      redirect_to(root_path) if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
