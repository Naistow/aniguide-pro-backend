class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :turbo_native_app?

  private

  def turbo_native_app?
    request.user_agent.to_s.include?("Turbo Native")
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_admin
    unless logged_in? && current_user.user_role.role_name == 'Admin'
      redirect_to root_path, alert: "Доступ запрещен. Требуются права администратора."
    end
  end
end
