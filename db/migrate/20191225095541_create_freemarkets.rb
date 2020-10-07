class CreateFreemarkets < ActiveRecord::Migration[5.2]
  def change
    create_table :freemarkets do |t|
      t.string :item, null: false
      t.integer :price, null: false
      t.string :condition, null: false
      t.string :ship_charge, null: false
      t.string :ship_from, null: false
      t.string :ship_day, null: false
      t.text :description, null: false
      t.integer :status, null: false, default: 1
      t.timestamps
    end
  end
end
