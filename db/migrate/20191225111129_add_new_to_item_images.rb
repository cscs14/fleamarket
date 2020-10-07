class AddNewToItemImages < ActiveRecord::Migration[5.2]
  def change
    add_reference :item_images, :freemarket, null: false, foreign_key: true
  end
end
