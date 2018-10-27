class Api::V1::MenusController < Api::V1::BaseController
  before_action :set_menu, only: [:show, :update, :destroy]

  # GET /menus
  def index
    @menus = Menu.select(:id, :name).includes(:sections).all.map do |m|
      m.attributes.merge({
        sections: m.sections.map { |s|
          items = []
          items = s.items.map(&:json) if s.items.present?
          { id: s.id, name: s.name, eng: s.eng, jpn: s.jpn, items: items }
        }
      })
    end

    render json: @menus
  end

  # GET /menus/1
  def show
    render json: @menu
  end

  # POST /menus
  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      render json: @menu, status: :created, location: @menu
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /menus/1
  def update
    if @menu.update(menu_params)
      render json: @menu
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  # DELETE /menus/1
  def destroy
    @menu.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def menu_params
      params.fetch(:menu, {}).permit(:name)
    end
end
