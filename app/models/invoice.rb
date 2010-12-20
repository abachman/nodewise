class Invoice < ActiveRecord::Base
  belongs_to :membership
  has_one :payment
end
