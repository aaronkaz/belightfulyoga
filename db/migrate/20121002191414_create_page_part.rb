class CreatePagePart < ActiveRecord::Migration
  def change
    create_table :page_parts do |t|
      t.string :title
      t.boolean :wysiwyg, :default => true
      t.boolean :required, :default => false    
      t.timestamps
    end
  end
end
