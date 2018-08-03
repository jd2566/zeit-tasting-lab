class Api::V1::ItemsController < Api::V1::BaseController
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /items
  def index
    @items = Item.select(:id, :category_id, :name, :eng, :jpn, :detail, :eng_detail, :jpn_detail)
                 .where(category_id: params[:category_id])
                 .with_attached_images.map(&:json)
    render json: @items
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    @item.category_id = params[:category_id]

    if @item.save
      item_data = @item.slice(:id, :name, :detail, :category_id).merge({images: []})
      render json: item_data, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item.slice(:id, :name, :eng, :jpn, :detail, :eng_detail, :jpn_detail, :category_id)
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
    img = @item.images.first

    render json: {
      item: @item.id,
      image: {
        id: img.id,
        name: img.filename,
        url: rails_blob_path(img.variant(resize: "480x480").processed.blob, only_path: true)
      }
    }
  end

  def del_image
    @item = Item.find(params[:item_id])
    @item.images.find_by_id(params[:id]).purge
    render json: {item: @item.id, image: params[:id]}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.fetch(:item, {}).permit(:name, :eng, :jpn, :detail, :eng_detail, :jpn_detail)
  end
end
