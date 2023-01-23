class MoneyTransaction < ApplicationRecord
  acts_as_paranoid

  has_many :wallet_transactions, dependent: :destroy
  belongs_to :transactionable, polymorphic: true
  belongs_to :targetable, polymorphic: true, optional: true
  
  validates :amount, numericality: { greater_than: 0 }

  validate :source_and_target_validation, on: :create
  validate :stock_must_enough, on: :create, if: -> { transaction_type.eql?('selling') }

  enum transaction_type: { deposit: 0, transfer: 1, buying: 2, selling: 3 }

  after_create :process_wallet_transaction
  after_create :generate_stock_item, if: -> { transaction_type.eql?('buying') }
  after_create :update_stock_deposit, if: -> { transaction_type.eql?('deposit') && transactionable_type.eql?('Stock') }
  after_create :update_stock_item, if: -> { transaction_type.eql?('buying') || transaction_type.eql?('selling') }

  attr_accessor :stock_id, :team_id, :user_id, :target_user_id, :target_team_id

  private

  def source_and_target_validation
    if transactionable_type == targetable_type && transactionable_id == targetable_id
      errors.add(:base, 'Transaction failed, Owner and Receiver cannot be same person!')
    end
  end

  def stock_must_enough
    errors.add(:base, 'Transaction failed, Stock is not enough!') if transactionable.stock_items.find_by(stock_id: targetable_id).amount < amount
  end

  def process_wallet_transaction
    case transaction_type
    when 'deposit'
      deposit_transaction
    when 'transfer'
      transfer_transaction
    when 'buying'
      buying_transaction
    else
      selling_transaction
    end
  end

  def deposit_transaction
    target_wallet   = transactionable.wallet
    new_transaction = target_wallet.wallet_transactions.create(money_transaction_id: id, event: 'debit', amount: amount)
  
    transaction_validation(new_transaction)
  end

  def transfer_transaction
    process_source_tansfer
    process_target_tansfer
  end

  def process_source_tansfer
    source_wallet   = transactionable.wallet
    new_transaction = source_wallet.wallet_transactions.create(money_transaction_id: id, event: 'credit', amount: -(amount))

    transaction_validation(new_transaction)
  end

  def process_target_tansfer
    target_wallet   = targetable.wallet
    new_transaction = target_wallet.wallet_transactions.create(money_transaction_id: id, event: 'debit', amount: amount)

    transaction_validation(new_transaction)
  end
  
  def buying_transaction
    process_source_buying
    process_target_buying
  end

  def process_source_buying
    targetable.with_lock do
      target_wallet   = transactionable.wallet
      new_amount      = targetable.conversion_rate * amount
      new_transaction = target_wallet.wallet_transactions.create(money_transaction_id: id, event: 'credit', amount: -(new_amount))

      transaction_validation(new_transaction)
    end
  end

  def process_target_buying
    targetable.with_lock do
      source_wallet   = targetable.wallet
      new_amount      = targetable.conversion_rate * amount
      new_transaction = source_wallet.wallet_transactions.create(money_transaction_id: id, event: 'debit', amount: new_amount)

      transaction_validation(new_transaction)
    end
  end

  def selling_transaction
    process_source_selling
    process_target_selling
  end

  def process_source_selling
    targetable.with_lock do
      target_wallet   = transactionable.wallet
      new_amount      = targetable.conversion_rate * amount
      new_transaction = target_wallet.wallet_transactions.create(money_transaction_id: id, event: 'debit', amount: new_amount)

      transaction_validation(new_transaction)
    end
  end

  def process_target_selling
    targetable.with_lock do
      source_wallet   = transactionable.wallet
      new_amount      = targetable.conversion_rate * amount
      new_transaction = source_wallet.wallet_transactions.create(money_transaction_id: id, event: 'debit', amount: new_amount)

      transaction_validation(new_transaction)
    end
  end

  def transaction_validation(transaction)
    if transaction.errors.present?
      errors.add(:base, transaction.errors.full_messages.join(', '))
      raise ActiveRecord::Rollback
    end
  end

  def generate_stock_item
    if transactionable.stock_items.where(stock_id: targetable_id).blank?
      transactionable.stock_items.create(stock_id: targetable_id, stockable_type: 'User', stockable_id: transactionable.id, amount: 0)
    end
  end

  def update_stock_deposit
    stock_item = transactionable.stock_item
    stock_item.with_lock do
      new_amount = stock_item.amount + amount
      stock_item.update(amount: new_amount)
    end
  end

  def update_stock_item
    process_first_stock
    process_second_stock
  end

  def process_first_stock
    stock_item = transaction_type.eql?('buying') ? targetable.stock_item : transactionable.stock_items.find_by(stock_id: targetable_id)
    stock_item.with_lock do
      new_amount = stock_item.amount - amount
      stock_item.update(amount: new_amount)
    end
  end

  def process_second_stock
    stock_item = transaction_type.eql?('buying') ? transactionable.stock_items.find_by(stock_id: targetable_id) : targetable.stock_item
    stock_item.with_lock do
      new_amount = stock_item.amount + amount
      stock_item.update(amount: new_amount)
    end
  end
end
