class MenusController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @menu = params[:id]
  end

  def data
    @sections = Section.includes(:items).where(menu_id: params[:id]).map { |s|
      { id: s.id, name: s.name, items: s.items.map(&:json) }
    }
    render json: @sections
  end

end
