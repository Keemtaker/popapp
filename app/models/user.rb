class User < ApplicationRecord
  after_create :retrieve_sales
  after_validation :set_slug, only: [:create, :update]


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sales, dependent: :destroy

  def to_param
    "#{id} + #{slug}"
  end



  def retrieve_sales
    $merchant_client = Square::Client.new(
      access_token: self.access_token,
      environment: ENV['SQUARE_ENVIRONMENT']
    )

    merchant_results = $merchant_client.merchants.retrieve_merchant(
      merchant_id: self.merchant_id
    )

    results = $merchant_client.orders.search_orders(
    body: {
      location_ids: [
        merchant_results.data["merchant"][:main_location_id]
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

    if results.data.present?
      customer_orders = results.data["orders"].select { |order| order[:customer_id].present? }
      if customer_orders.present?
        new_sale_array = []
        customer_orders.each do | order |
          customer_details = $merchant_client.customers.retrieve_customer(
          customer_id: order[:customer_id]
        )

          new_sale = Sale.new(user_id: self.id, customer_name: customer_details.data["customer"][:given_name], customer_locality: customer_details.data["customer"][:address][:locality],
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
    end
  end


  private

  def set_slug
    self.slug = merchant_id[0..2].to_s.parameterize
  end

  def email_required?
     false
  end
end
