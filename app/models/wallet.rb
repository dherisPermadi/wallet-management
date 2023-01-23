class Wallet < ApplicationRecord
  has_many :wallet_transactions
  belongs_to :walletable, polymorphic: true, optional: true

  def balance
    wallet_transactions.sum(:amount)
  end
end
