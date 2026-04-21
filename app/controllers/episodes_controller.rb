class EpisodesController < ApplicationController
  def create
    work = Work.find(params[:work_id])
    episode = work.episodes.new(episode_params)
    
    # Подстраховка: если в базе осталось обязательное поле episode_number, заполняем его автоматом
    episode.episode_number = work.episodes.count + 1 if episode.respond_to?(:episode_number=)

    if episode.save
      head :ok
    else
      # Если не сохранилось, отправляем текст ошибки в браузер
      render json: { error: episode.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue => e
    # Ловим критические ошибки базы данных (тот самый код 500) и отдаем текстом
    render json: { error: e.message }, status: 500
  end

  def update
    episode = Episode.find(params[:id])
    if episode.update(episode_params)
      head :ok
    else
      render json: { error: episode.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end

  def add_character
    episode = Episode.find(params[:id])
    character = Character.find(params[:character_id])
    episode.characters << character unless episode.characters.include?(character)
    head :ok
  rescue => e
    render json: { error: e.message }, status: 500
  end

  def remove_character
    episode = Episode.find(params[:id])
    character = Character.find(params[:character_id])
    episode.characters.delete(character)
    head :ok
  rescue => e
    render json: { error: e.message }, status: 500
  end

  private

  def episode_params
    params.require(:episode).permit(:title, :description, :duration)
  end
end