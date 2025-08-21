class ProfilesController < ApplicationController
  before_action :require_login

  def edit
    @user_model = current_user
  end

  def update
    @user_model = current_user
    if @user_model.update(profile_params)
      redirect_to @user_model, notice: 'プロフィール更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_model).permit(:name, :bio, :icon_image)
  end
end
