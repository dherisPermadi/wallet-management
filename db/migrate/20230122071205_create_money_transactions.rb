class CreateMoneyTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :money_transactions do |t|
      t.references :transactionable, polymorphic: true
      t.integer    :transaction_type, null: false, default: 0
      t.decimal    :amount, precision: 20, scale: 2
      t.references :targetable, polymorphic: true
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :money_transactions, [:transactionable_id, :transactionable_type], name: 'transactionable_index'
    add_index :money_transactions, [:targetable_id, :targetable_type]
  end
end
