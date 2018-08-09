class Api::V1::MatchesController < Api::V1::BaseController
  before_action :set_match, only: [:show, :update, :destroy]

  # GET /matches
  def index
    @matches = Match.all

    render json: @matches
  end

  # GET /matches/1
  def show
    render json: @match
  end

  # POST /matches
  def create
    @match = Match.new(match_params)
    @match.category = Category.where(root_category_id: 2, name: params[:category]).first

    if @match.save
      @match.items << Item.where(id: params[:items])
      render json: {match: @match, items: @match.items.with_attached_images.map(&:json)}, status: :created
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      @match.items = Item.where(id: params[:items])
      render json: {match: @match, items: @match.items.with_attached_images.map(&:json)}
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def match_params
      params.fetch(:match, {})
            .permit(:category_id, :name, :eng, :jpn, :detail, :how_to,
                    :eng_detail, :jpn_detail, :eng_how_to, :jpn_how_to)
    end
end
