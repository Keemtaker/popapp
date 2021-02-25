class AddAccessTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_token, :string
    add_column :users, :merchant_id, :string
    add_column :users, :refresh_token, :string
    add_column :users, :access_token_expires_at, :string
  end
end
