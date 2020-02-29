class CreateItemBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :item_bulk_discounts do |t|
      t.references :item, foreign_key: true
      t.references :bulk_discount, foreign_key: true
    end
  end
end
