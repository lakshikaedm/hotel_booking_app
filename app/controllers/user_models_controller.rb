class UserModelsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_me, only: [:edit, :update]
  
  def new
    @user_model = UserModel.new
  end

  def create
    @user_model = UserModel.new(user_params)
    if @user_model.save
      session[:user_model_id] = @user_model.id
      redirect_to @user_model, notice: 'ようこそ！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    attrs = user_params.dup
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation)
    end

    if @user_model.update(attrs)
      redirect_to @user_model, notice: 'アカウントを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_model = current_user
    return redirect_to root_path, alert: "許可されていません。" unless @user_model

    @user_model.destroy
    reset_session
    redirect_to root_path, notice: "アカウントを削除しました。"
  end

  private
  def set_user
    @user_model = current_user
  end

  def authorize_me
    redirect_to root_path, alert: '許可されていません。' unless @user_model == current_user
  end

  def user_params
    params.require(:user_model).permit(:name, :email, :password, :password_confirmation)
  end
end
