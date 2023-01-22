class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string   :name
      t.decimal  :conversion_rate, precision: 5, scale: 2, default: 0
      t.boolean  :status, default: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
