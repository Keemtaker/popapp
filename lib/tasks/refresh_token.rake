desc "This task refreshes access token"

task :refresh => :environment do

  User.all.each do | user |
    result = $client.o_auth.obtain_token(
    body: {
      client_id: ENV['SQUARE_APPLICATION_ID'],
      client_secret: ENV['SQUARE_APPLICATION_SECRET'],
      grant_type: "refresh_token",
      refresh_token: user.refresh_token
    }
  )

    user.update(access_token: result.data.access_token)
    user.update(access_token_expires_at: result.data.expires_at)
  end

end
