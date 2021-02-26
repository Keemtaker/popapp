class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :callback ]

  def home
    @api_permission = 'MERCHANT_PROFILE_READ+CUSTOMERS_READ+ORDERS_READ+ITEMS_READ+ORDERS_WRITE+PAYMENTS_WRITE'
    recent_sales = Sale.all.limit(10).order("id DESC")
    @sale = recent_sales.sample

    # sampled_line_item = JSON.parse @sale.line_items.sample.gsub('=>', ':')
    # @line_item_name = sampled_line_item["name"]
  end

  def callback
    authorization_code_value = params[:code]

      result = $client.o_auth.obtain_token(
        body: {
          client_id: ENV['SQUARE_APPLICATION_ID'],
          client_secret: ENV['SQUARE_APPLICATION_SECRET'],
          code: authorization_code_value,
          grant_type: "authorization_code"
        }
      )

    if result.success?
      user = User.find_or_initialize_by(merchant_id: result.data.merchant_id)
      user.password = Devise.friendly_token[0, 20]
      user.access_token = result.data.access_token
      user.refresh_token = result.data.refresh_token
      user.merchant_id = result.data.merchant_id
      user.access_token_expires_at = result.data.expires_at
      user.save!
      sign_in user if user.save
    elsif result.error?
      redirect_to root_path
      flash[:notice] = "Something went wrong with the authentication process"
    end
  end

end
