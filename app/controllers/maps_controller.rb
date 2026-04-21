class MapsController < ApplicationController
  def show
    @franchise = Franchise.find(params[:id])
    @works = Work.where(franchise: @franchise).where.not(pos_x: nil)
    
    # Мы убрали 'render layout: false', теперь карта будет выводиться 
    # внутри твоего application.html.erb (вместе с навигационной панелью!)
  end

  def update_coordinates
    work = Work.find(params[:id])
    work.update(pos_x: params[:pos_x], pos_y: params[:pos_y])
    head :ok
  end

  def create_node
    current_franchise = Franchise.find(params[:franchise_id])
    tv_type = MediaType.find_by(name: 'TV Series') || MediaType.first
    new_title = params[:title].present? ? params[:title] : "Новый сезон"

    new_work = Work.create!(
      title: new_title,
      franchise: current_franchise,
      media_type: tv_type,
      parent_id: params[:parent_id],
      pos_x: params[:pos_x],
      pos_y: params[:pos_y],
      image_url: params[:image_url]
    )

    render json: { id: new_work.id, title: new_work.title, pos_x: new_work.pos_x, pos_y: new_work.pos_y, parent_id: new_work.parent_id, image_url: new_work.image_url }
  end

  def update_node
    work = Work.find(params[:id])
    p_id = params[:parent_id].present? ? params[:parent_id] : nil
    work.update(title: params[:title], parent_id: p_id, image_url: params[:image_url])
    head :ok
  end

  def delete_node
    work = Work.find(params[:id])
    Work.where(parent_id: work.id).update_all(parent_id: nil)
    work.destroy
    head :ok
  end
end