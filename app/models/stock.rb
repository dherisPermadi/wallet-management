
class Stock < ApplicationRecord
  acts_as_paranoid

  validates_presence_of :name
  validates :name, uniqueness: { scope: :deleted_at }
  validates :conversion_rate, numericality: { greater_than: 0 }
end
