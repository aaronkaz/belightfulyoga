class AddToPages < ActiveRecord::Migration
  def change
    add_column :pages, :add_css, :string
    add_column :pages, :meta_description, :text
    add_column :pages, :meta_keywords, :text
    add_column :pages, :google_analytics, :boolean, :default => true
  end
end
