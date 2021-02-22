class AddTimestampsToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :sale_created_at, :string
    add_column :sales, :sale_updated_at, :string
  end
end
