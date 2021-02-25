class RemoveAccessTokenToSales < ActiveRecord::Migration[6.0]
  def change
    remove_column :sales, :access_token, :string
    remove_column :sales, :merchant_id, :string
    remove_column :sales, :refresh_token, :string
    remove_column :sales, :access_token_expires_at, :string
  end
end
