class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :callback, :show ]
  protect_from_forgery except: :show

  def show
    @user = User.find(params[:id])
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
      if user.save
        sign_in user
        redirect_to profile_path
      else
        redirect_to root_path
        flash[:notice] = "Something went wrong with the authentication process"
      end
    elsif result.error?
      redirect_to root_path
      flash[:notice] = "Something went wrong with the authentication process"
    end
  end

  def profile
    @user = current_user
  end
end
