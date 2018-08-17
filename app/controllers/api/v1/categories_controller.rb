class Api::V1::CategoriesController < Api::V1::BaseController
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.includes(:items).select(:id, :name).all.map {|c| c.attributes.merge({items: c.items.size}) }

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
  end

  def match_categories
    @matches = Category.includes(:matches)
                       .select(:id, :name).where(root_category_id: 2)
    render json: @matches
  end

  def matches
    category_id = Category.find_by(name: params[:category_id]).id
    @matches = Match.includes(:items).where(category_id: category_id).map do |m|
      {
        match: m.attributes.except("created_at", "updated_at"),
        items: m.items.with_attached_images.map(&:json)
      }
    end

    render json: @matches
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.fetch(:categories, {}).permit(:root_category_id, :name)
  end
end
