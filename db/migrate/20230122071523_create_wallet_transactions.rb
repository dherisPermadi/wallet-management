class CreateWalletTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_transactions do |t|
      t.references :money_transaction
      t.references :wallet
      t.integer    :event, null: false, default: 0
      t.decimal    :amount, precision: 20, scale: 2
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
