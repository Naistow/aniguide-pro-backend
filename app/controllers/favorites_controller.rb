class FavoritesController < ApplicationController
  def create
    if !defined?(current_user) || current_user.nil?
      return render json: { error: "Войдите в аккаунт" }, status: :unauthorized
    end
    
    fav = current_user.favorites.new
    fav.work_id = params[:work_id] if params[:work_id].present?
    fav.character_id = params[:character_id] if params[:character_id].present?
    
    if fav.save
      head :ok
    else
      render json: { error: fav.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    fav = current_user.favorites.find(params[:id])
    fav.destroy
    head :ok
  end
end