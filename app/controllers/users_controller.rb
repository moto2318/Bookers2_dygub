class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # @following_users = @user.following_users
    # @follower_users = @user.follower_users
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
    @books = Book.all
  end


  def edit
    ensure_correct_user
     @user = User.find(params[:id])
  end

  def update
    ensure_correct_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      @books = @user.books
      render :edit
    end
  end


  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end

  private

  def user_params(width, heigth)
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
