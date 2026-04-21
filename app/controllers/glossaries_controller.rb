class GlossariesController < ApplicationController
  def create
    if defined?(current_user) && current_user.try(:admin?)
      franchise = Franchise.find(params[:id])
      
      # Создаем только с названием, остальное - потом
      item = franchise.glossaries.new(title: params[:title])
      
      if item.save
        head :ok
      else
        render json: { error: item.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end

  def update
    if defined?(current_user) && current_user.try(:admin?)
      item = Glossary.find(params[:id])
      
      # Разрешаем сохранять название, описание и файл картинки
      if item.update(params.require(:glossary).permit(:title, :description, :image))
        head :ok
      else
        render json: { error: item.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end

  def destroy
    if defined?(current_user) && current_user.try(:admin?)
      item = Glossary.find(params[:id])
      item.destroy
      head :ok
    else
      head :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end