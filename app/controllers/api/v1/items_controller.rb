class Api::V1::ItemsController < Api::V1::BaseController
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /items
  def index
    @items = Item.select(:id, :category_id, :name, :detail)
                 .where(category_id: params[:category_id])
                 .with_attached_images.map do |i|
      i.attributes.merge({
        images: i.images.map.with_index { |im, index|
          {
            name: im.filename,
            url: url_for(im),
          }
        },
      })
    end
    render json: @items.group_by{|d| d["category_id"] }
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.category_id = params[:category_id]
    item_data = @item.slice(:id, :name, :detail, :category_id).merge({images: []})
    if @item.save
      render json: item_data, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item.slice(:id, :name, :detail, :category_id)
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  def image
    @item = Item.find(params[:item_id])
    @item.images.attach(params[:file])
    head :ok
  end

  def del_image
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.fetch(:item, {}).permit(:name, :detail)
  end
end
