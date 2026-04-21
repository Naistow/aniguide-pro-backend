class CharactersController < ApplicationController
  def show
    @character = Character.find(params[:id])
    
    if @character.respond_to?(:episodes)
      @episodes = @character.episodes.includes(:work)
      @works = @episodes.map(&:work).compact.uniq
    else
      @episodes = []
      @works = []
    end
  end

  def create
    if defined?(current_user) && current_user.try(:admin?)
      franchise = Franchise.find(params[:id])
      
      role = CharacterRole.first || CharacterRole.create!(name: "Неизвестно")
      char = franchise.characters.new(name: params[:name], character_role: role)
      
      if char.save
        head :ok
      else
        render json: { error: char.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end

  def update
    @character = Character.find(params[:id])
    
    if defined?(current_user) && current_user.try(:admin?)
      if @character.update(params.require(:character).permit(:name, :description, :portrait))
        head :ok
      else
        render json: { error: @character.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end