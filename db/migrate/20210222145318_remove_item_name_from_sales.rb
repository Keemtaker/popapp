class RemoveItemNameFromSales < ActiveRecord::Migration[6.0]
  def change
    remove_column :sales, :item_name, :string
    remove_column :sales, :item_price, :string
  end
end
