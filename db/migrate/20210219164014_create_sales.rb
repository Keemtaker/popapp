class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.string :customer_name
      t.string :customer_locality
      t.string :item_name
      t.string :item_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
