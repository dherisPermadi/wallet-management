class Team < ApplicationRecord
  acts_as_paranoid

  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :money_transactions, as: :transactionable, dependent: :destroy

  validates_presence_of :name
  validates :name, uniqueness: { scope: :deleted_at }

  before_create :generate_wallet

  private

  def generate_wallet
    self.build_wallet
  end
end
