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
      temp_categories = {}
      {
        id: s.id, name: name,
        items: s.items.includes(:matches).map { |i|
          matches = i.matches.includes(:items, :category).each { |m|
            if temp_categories[m.category.name].nil?
              temp_categories[m.category.name] = []
            end
            temp_categories[m.category.name] <<
                  m.items.select{|mm| mm.id != i.id }.map(&:simple_json)
            temp_categories[m.category.name] = temp_categories[m.category.name].flatten.uniq
          }
          categories = []
          temp_categories.each {|c|
            categories << {
              name: c[0],
              items: c[1]
            }
          }

          i.json.merge({matches: categories})
        }
      }
    }
    render json: @sections
  end

end
