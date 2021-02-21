$client = Square::Client.new(
    access_token: ENV['SQUARE_ACCESS_TOKEN'],
    environment: ENV['SQUARE_ENVIRONMENT']
)
