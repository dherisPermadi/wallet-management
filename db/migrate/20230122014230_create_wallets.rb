class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :walletable, polymorphic: true
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :wallets, [:walletable_id, :walletable_type]
  end
end
