class MenusController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @menu = params[:id]
    @lang = params[:lang]
  end

  def data
    @sections = Section.includes(:items).where(menu_id: params[:id]).map { |s|
      name = s.name if params[:lang] == 'tw'
      name = s.eng  if params[:lang] == 'us'
      name = s.jpn  if params[:lang] == 'jp'
      { id: s.id, name: name, items: s.items.map(&:json) }
    }
    render json: @sections
  end

end
