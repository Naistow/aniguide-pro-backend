class WorksController < ApplicationController
  def show
    @work = Work.find(params[:id])
    @episodes = @work.respond_to?(:episodes) ? @work.episodes.order(:id) : []
  end

  def update
    @work = Work.find(params[:id])
    
    # Защита: разрешаем обновление только админам
    if defined?(current_user) && current_user.try(:admin?)
      if @work.update(work_params)
        head :ok
      else
        render json: { errors: @work.errors.full_messages }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  end

  private

  def work_params
    # Разрешаем изменять только поле description
    params.require(:work).permit(:description)
  end
end