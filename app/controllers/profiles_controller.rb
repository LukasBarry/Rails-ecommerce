class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:email, :name, :username, :birthday, :bio, :latitude, :longitude, :user_id, :avatar)
  end
end
