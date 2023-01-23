
class Stock < ApplicationRecord
  acts_as_paranoid

  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :money_transactions, as: :transactionable, dependent: :destroy
  has_many :stock_items
  has_one :stock_item, as: :stockable, dependent: :destroy

  validates_presence_of :name
  validates :name, uniqueness: { scope: :deleted_at }
  validates :conversion_rate, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  before_create :generate_wallet
  after_create :generate_stock_item

  private

  def generate_wallet
    self.build_wallet
  end

  def generate_stock_item
    self.stock_items.create(stockable_type: 'Stock', stockable_id: id, amount: 0)
  end
end
