class MenusController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @menu = params[:id]
    @lang = params[:lang]
  end

  def data
    @sections = Section.includes(:items).where(menu_id: params[:id]).map { |s|
      if params[:lang] == 'tw'
        name = s.name
      end
      if params[:lang] == 'us'
        name = s.eng
      end
      if params[:lang] == 'jp'
        name = s.jpn
      end

      section_items = s.items.includes(:matches).map do |i|
        matches = i.matches.includes(:items, :category)
        categories = Category.where(id: matches.pluck(:category_id).uniq).map do |c|
          {
            id: c.id,
            name: c.name,
            items: []
          }
        end
        matches.each do |m|
          matching_cat = categories.detect{ |c| c[:id] == m.category_id }
          matching_cat[:items] = m.items.with_attached_images
                                  .select {|m| m.id != i.id }.map(&:simple_json)
        end

        i.json.merge({matches: categories})
      end

      {
        id: s.id, name: name,
        items: section_items
      }
    }

    render json: @sections
  end

end
