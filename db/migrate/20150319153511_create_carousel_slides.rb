class CreateCarouselSlides < ActiveRecord::Migration
  def change
    create_table :carousel_slides do |t|
      t.string :image
      t.string :url
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end
