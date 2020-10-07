class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, unll: false, foreign_key: true
      t.references :freemarket, unll: false, foreign_key: true
      t.references :deliver_address, unll: false, foreign_key: true
      t.timestamps
    end
  end
end
