class User < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :money_transactions, as: :transactionable, dependent: :destroy
  has_many :stock_items, as: :stockable, dependent: :destroy

  enum user_type: { customer: 0, admin: 1 }

  validates :email, uniqueness: { scope: :deleted_at }
  validates_presence_of :email, :name

  before_create :generate_wallet

  private

  def generate_wallet
    self.build_wallet
  end
end
