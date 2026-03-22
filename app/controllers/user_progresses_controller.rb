class UserProgressesController < ApplicationController
  before_action :require_login

  def update_or_create
    @progress = current_user.user_progresses.find_or_initialize_by(work_id: params[:work_id])
    
    if params[:status].blank?
      @progress.destroy if @progress.persisted?
      message = "Статус сброшен"
    else
      @progress.status = params[:status]
      @progress.save
      message = "Статус обновлен: #{status_text(@progress.status)}"
    end

    redirect_back fallback_location: root_path, notice: message
  end

  private

  def status_text(status)
    { 'planned' => 'В планах', 'watching' => 'Смотрю', 'completed' => 'Просмотрено' }[status]
  end

  def require_login
    redirect_to login_path, alert: "Нужно войти в систему" unless logged_in?
  end
end