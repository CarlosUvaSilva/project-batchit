class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :group_size
      t.date :start_date
      t.date :end_date
      t.text :description
      t.boolean :ongoing

      t.timestamps
    end
  end
end
