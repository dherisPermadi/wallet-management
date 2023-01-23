class CreateStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_items do |t|
      t.references :stock
      t.references :stockable, polymorphic: true
      t.decimal    :amount, precision: 20, scale: 2
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :stock_items, [:stockable_id, :stockable_type]
  end
end
