class AddCountryToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :customer_country, :string
  end
end
