class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.float :percentage_off
      t.integer :required_quantity
    end
  end
end
