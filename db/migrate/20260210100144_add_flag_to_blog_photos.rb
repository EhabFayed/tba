class AddFlagToBlogPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :blog_photos, :is_landing, :boolean, default: false
  end
end
