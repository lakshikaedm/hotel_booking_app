class SessionsController < ApplicationController
  def new;
  end

  def create
    user = UserModel.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      reset_session
      session[:user_model_id] = user.id
      target = params[:return_to].presence || user
      redirect_to target, notice: 'ログインしました。'
    else
      flash.now[:alert] = '無効なメールアドレスまたはパスワード'
      render :new, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end
end
