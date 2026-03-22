class FavoritesController < ApplicationController
  before_action :require_login

  def create
    # Логика создания избранного персонажа
    @favorite = current_user.favorites.build(character_id: params[:character_id])
    if @favorite.save
      redirect_back fallback_location: root_path, notice: "Персонаж добавлен в избранное!"
    else
      redirect_back fallback_location: root_path, alert: "Не удалось добавить в избранное."
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: root_path, notice: "Удалено из избранного."
  end

  private

  def require_login
    redirect_to login_path unless logged_in?
  end
end