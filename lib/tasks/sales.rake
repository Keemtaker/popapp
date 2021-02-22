
desc "This task retrieves completed orders"

task :sales => :environment do

  results = $client.orders.search_orders(
  body: {
    location_ids: [
      "LF9R80C1T6BS3"
    ],
    query: {
      filter: {
        state_filter: {
          states: [
            "COMPLETED"
          ]
        }
      }
    }
  }
)

  completed_orders = results.data["orders"].select { |order| order[:customer_id].present? }
  new_sale_array = []
  completed_orders.each do | order |
    customer_details = $client.customers.retrieve_customer(
    customer_id: order[:customer_id]
  )

    new_sale = Sale.new(user_id: User.first.id, customer_name: customer_details.data["customer"][:given_name], customer_locality: customer_details.data["customer"][:address][:locality],
                        customer_country: customer_details.data["customer"][:address][:country], sale_created_at: order[:created_at], sale_updated_at: order[:updated_at])

    order[:line_items].each do | line_item |
      new_sale_array << {"catalog_object_id" => line_item[:catalog_object_id], "name" => line_item[:name], "price_total" => line_item[:total_money][:amount],
      "price_currency" => line_item[:total_money][:currency]}
    end
    new_sale.line_items = new_sale_array
    new_sale.save!
    new_sale_array = []
  end
end

#User signs up through oauth
#Create user and populate location id field in database
#Retrieve the recent completed orders using the signed in user location id
#Get info such as line items using catalog api
#Get Customer info using customer api
