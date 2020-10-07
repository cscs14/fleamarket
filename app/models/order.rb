class Order < ApplicationRecord
  belongs_to :user
  belongs_to :freemarket
  belongs_to :deliver_address
end
