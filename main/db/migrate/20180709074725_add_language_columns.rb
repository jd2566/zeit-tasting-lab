class AddLanguageColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :eng, :string, after: :name
    add_column :items, :jpn, :string, after: :eng

    add_column :items, :eng_detail, :text, after: :detail
    add_column :items, :jpn_detail, :text, after: :eng_detail

    add_column :matches, :eng, :string, after: :name
    add_column :matches, :jpn, :string, after: :eng

    add_column :matches, :eng_detail, :text, after: :detail
    add_column :matches, :jpn_detail, :text, after: :eng_detail

    add_column :matches, :eng_how_to, :string, after: :how_to
    add_column :matches, :jpn_how_to, :string, after: :eng_how_to

    add_column :sections, :eng, :string, after: :name
    add_column :sections, :jpn, :string, after: :eng

    add_column :categories, :eng, :string, after: :name
    add_column :categories, :jpn, :string, after: :eng
  end
end
