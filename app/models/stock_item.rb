class StockItem < ApplicationRecord
  belongs_to :stock
  belongs_to :stockable, polymorphic: true, optional: true
end
