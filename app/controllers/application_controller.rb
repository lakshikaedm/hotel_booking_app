class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= UserModel.find_by(id: session[:user_model_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to new_session_path, alert: 'ログインしてください。' unless logged_in?
  end
end
