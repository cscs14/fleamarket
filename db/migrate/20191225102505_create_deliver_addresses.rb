class CreateDeliverAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :deliver_addresses do |t|
      t.string :postal_code, null: false
      t.string :prefecture_id, null: false
      t.string :city, null: false
      t.string :street_address, null: false
      t.string :building_name, null: true
      t.string :phone, null: true
      t.timestamps
    end
  end
end
