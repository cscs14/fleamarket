class AddNewToDeliverAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :deliver_addresses, :user, null: false, foreign_key: true
  end
end
