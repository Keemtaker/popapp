class AddAccessTokenToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :access_token, :string
    add_column :sales, :merchant_id, :string
    add_column :sales, :refresh_token, :string
    add_column :sales, :access_token_expires_at, :string
  end
end
