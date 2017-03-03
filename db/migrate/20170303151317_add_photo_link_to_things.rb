class AddPhotoLinkToThings < ActiveRecord::Migration[5.0]
  def change
    add_column :things, :photo_link, :string
  end
end
