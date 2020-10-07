class DeliverAddress < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

with_options on: :deliver_address do | deliver_address |
  deliver_address.validates :postal_code,
    presence: true,
    format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'のフォーマットが不適切です'}
  deliver_address.validates :prefecture_id,
    presence: true
  deliver_address.validates :city,
    presence: true,
    length:{ maximum: 50}
  deliver_address.validates :street_address,
    presence: true,
    length:{ maximum: 100}
  deliver_address.validates :building_name,
    length:{ maximum: 100}
end

end