class HomeController < ApplicationController
  def index
    @franchises = Franchise.all
  end

  def guide
    @franchise = Franchise.find(params[:id])
    guide = @franchise.watch_guides.first
    @steps = guide ? guide.guide_steps.includes(work: :media_type).order(:step_number) : []
  end

  def characters
    @franchise = Franchise.find(params[:id])
    @characters = @franchise.characters.includes(:character_role)
  end

  def glossary
    @franchise = Franchise.find(params[:id])
    @terms = @franchise.lore_glossaries.order(:term)
  end

  def character_show
    @character = Character.find(params[:id])
    @franchise = @character.franchise
    
    # Подгружаем и общие появления в тайтлах, и конкретные эпизоды
    @appearances = @character.appearances.includes(:work).order('works.release_year ASC')
    @episodes = @character.episodes.includes(:work).order('works.release_year ASC, episodes.episode_number ASC')
  end

  def work_show
    @work = Work.find(params[:id])
    @franchise = @work.franchise
    # Подгружаем эпизоды ВМЕСТЕ с персонажами и их ролями для оптимизации БД
    @episodes = @work.episodes.includes(characters: :character_role).order(:episode_number)
  end

  def search
    @query = params[:query]
    if @query.present?
      @franchises = Franchise.where("name LIKE ?", "%#{@query}%")
      @characters = Character.where("name LIKE ? OR biography LIKE ?", "%#{@query}%", "%#{@query}%")
      @terms = LoreGlossary.where("term LIKE ? OR definition LIKE ?", "%#{@query}%", "%#{@query}%")
    else
      @franchises = @characters = @terms = []
    end
  end
end