class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def profile
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(profile_params)
      redirect_to profile_user_path(user)
      flash[:notice] = '変更しました'
    else
      render 'profile'
      flash[:alert] = '変更に失敗しました'
    end
  end

  def logout
  end

  def purchased
    @orders = Order.where(user_id: current_user.id).includes(:freemarket).limit(10).order('id DESC')
  end

  def list
    @freemarkets = Freemarket.where(user_id: current_user.id, status: 1).limit(10).order('id DESC')
  end

  def complete
    @freemarkets = Freemarket.where(user_id: current_user.id, status: 2).limit(10).order('id DESC')
  end

  private

  def profile_params
    params.require(:user).permit(:nickname, :profile_content)
  end

end
