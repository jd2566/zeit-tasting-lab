class Api::V1::SectionsController < Api::V1::BaseController
  before_action :set_section, only: [:show, :update, :destroy]

  # GET /sections
  def index
    @sections = Section.all

    render json: @sections
  end

  # GET /sections/1
  def show
    render json: @section
  end

  # POST /sections
  def create
    @section = Section.new(section_params)
    @section.menu_id = params[:menu_id]

    if @section.save
      render json: @section, status: :created
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sections/1
  def update
    if @section.update(section_params)
      render json: @section
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sections/1
  def destroy
    @section.destroy
  end

  def add_items
    @section = Section.find(params[:section_id])
    items = Item.where(id: params[:items_id])

    @section.items << items
    head :ok
  end

  def remove_item
    target = ItemSectionShip.where(item_id: params[:item_id], section_id: params[:section_id]).first
    head :ok if target.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def section_params
      params.fetch(:section, {}).permit(:name, :eng, :jpn)
    end
end
