class AdminController < ApplicationController
  before_action :require_admin

  def index
    @franchises = Franchise.all
  end

  # ==========================================
  # ПЕРСОНАЖИ
  # ==========================================
  def new_character
    @character = Character.new
    @franchise = Franchise.find(params[:franchise_id]) if params[:franchise_id]
  end

  def create_character
    @character = Character.new(character_params)
    if @character.save
      redirect_to franchise_characters_path(@character.franchise), notice: "Персонаж создан!"
    else
      render :new_character, status: :unprocessable_entity
    end
  end

  def edit_character
    @character = Character.find(params[:id])
    @franchise = @character.franchise
  end

  def update_character
    @character = Character.find(params[:id])
    if @character.update(character_params)
      redirect_to character_profile_path(@character), notice: "Анкета обновлена!"
    else
      render :edit_character, status: :unprocessable_entity
    end
  end

  def destroy_character
    char = Character.find(params[:id])
    franchise = char.franchise
    char.destroy
    redirect_to franchise_characters_path(franchise), notice: "Персонаж удален"
  end

  # ==========================================
  # ГЛОССАРИЙ (Исправлено)
  # ==========================================
  def new_glossary
    # Вот эта строка решает ошибку ArgumentError (nil)
    @term = LoreGlossary.new
    @franchise = Franchise.find(params[:franchise_id]) if params[:franchise_id]
  end

  def create_glossary
    @term = LoreGlossary.new(params.require(:lore_glossary).permit(:term, :definition, :franchise_id))
    if @term.save
      redirect_to franchise_glossary_path(@term.franchise)
    else
      render :new_glossary, status: :unprocessable_entity
    end
  end

  def edit_glossary
    @term = LoreGlossary.find(params[:id])
    @franchise = @term.franchise
  end

  def update_glossary
    @term = LoreGlossary.find(params[:id])
    if @term.update(params.require(:lore_glossary).permit(:term, :definition, :franchise_id))
      redirect_to franchise_glossary_path(@term.franchise)
    else
      render :edit_glossary, status: :unprocessable_entity
    end
  end

  def destroy_glossary
    term = LoreGlossary.find(params[:id])
    franchise = term.franchise
    term.destroy
    redirect_to franchise_glossary_path(franchise)
  end

  # ==========================================
  # ЭПИЗОДЫ
  # ==========================================
  def new_episode
    @episode = Episode.new
    @work = Work.find(params[:work_id]) if params[:work_id]
    # Получаем всех персонажей этой франшизы для выбора
    @available_characters = @work ? @work.franchise.characters : []
  end

def create_episode
    # Обрати внимание на character_ids: [] - это массив выбранных персонажей
    @episode = Episode.new(params.require(:episode).permit(:work_id, :episode_number, :title, :description, character_ids: []))
    if @episode.save
      redirect_to work_profile_path(@episode.work), notice: "Эпизод добавлен!"
    else
      @work = @episode.work
      @available_characters = @work.franchise.characters
      render :new_episode, status: :unprocessable_entity
    end
  end

  def destroy_episode
    episode = Episode.find(params[:id])
    work = episode.work
    episode.destroy
    redirect_to work_profile_path(work)
  end

  # ==========================================
  # ГАЙДЫ (ТАЙТЛЫ)
  # ==========================================
  def new_work
    @work = Work.new
    @franchise = Franchise.find(params[:franchise_id]) if params[:franchise_id]
  end

def create_work
    # Добавил :synopsis
    @work = Work.new(params.require(:work).permit(:title, :release_year, :synopsis, :media_type_id, :franchise_id))
    if @work.save
      guide = WatchGuide.find_or_create_by!(franchise_id: @work.franchise_id)
      step_num = (guide.guide_steps.maximum(:step_number) || 0) + 1
      GuideStep.create!(watch_guide: guide, work: @work, step_number: step_num)
      redirect_to guide_path(@work.franchise)
    else
      render :new_work, status: :unprocessable_entity
    end
  end

  def destroy_work
    work = Work.find(params[:id])
    franchise = work.franchise
    work.destroy
    redirect_to guide_path(franchise)
  end

  # ==========================================
  # ПОЯВЛЕНИЯ ПЕРСОНАЖЕЙ В ТАЙТЛАХ
  # ==========================================
  def new_appearance
    @appearance = Appearance.new
    @character = Character.find(params[:character_id]) if params[:character_id]
    @works = @character ? @character.franchise.works : Work.all
  end

  def create_appearance
    @appearance = Appearance.new(params.require(:appearance).permit(:character_id, :work_id, :episodes))
    if @appearance.save
      redirect_to character_profile_path(@appearance.character)
    else
      render :new_appearance, status: :unprocessable_entity
    end
  end

  def destroy_appearance
    app = Appearance.find(params[:id])
    character = app.character
    app.destroy
    redirect_to character_profile_path(character)
  end

  private

  def character_params
    params.require(:character).permit(:name, :biography, :plot_role, :backstory, :history, :status, :franchise_id, :character_role_id, :portrait)
  end
end