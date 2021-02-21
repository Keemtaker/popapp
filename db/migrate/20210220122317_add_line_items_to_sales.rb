class AddLineItemsToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :line_items, :text, array: true, default: []
  end
end
