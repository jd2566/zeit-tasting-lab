class Api::V1::RootCategoriesController < Api::V1::BaseController
  before_action :set_root_category, only: [:show, :update, :destroy]

  # GET /root_categories
  def index
    @root_categories = RootCategory.includes(:categories)
                                   .select(:id, :name).all.map do |r|
      r.attributes.merge({
        categories: r.categories.map { |c|
          {
            id: c.id,
            name: c.name
          }
        }
      })
    end

    render json: @root_categories
  end

  # GET /root_categories/1
  def show
    render json: @root_category
  end

  # POST /root_categories
  def create
    @root_category = RootCategory.new(root_category_params)

    if @root_category.save
      render json: @root_category, status: :created
    else
      render json: @root_category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /root_categories/1
  def update
    if @root_category.update(root_category_params)
      render json: @root_category
    else
      render json: @root_category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /root_categories/1
  def destroy
    @root_category.destroy
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_root_category
    @root_category = RootCategory.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def root_category_params
    params.fetch(:root_categories, {}).permit(:name)
  end
end
