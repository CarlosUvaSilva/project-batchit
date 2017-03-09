class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :participant_id
      t.integer :project_id

      t.timestamps
    end
  end
end
