class CreateThings < ActiveRecord::Migration[5.0]
  def change
    create_table :things do |t|
      t.string :name
      t.string :address
      t.text :description
      t.integer :price_range
      t.integer :city_id
      t.string :thing_type
      t.string :link
      t.text :tag

      t.timestamps
    end
  end
end
