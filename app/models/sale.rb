class Sale < ApplicationRecord
  belongs_to :user

  validates :customer_name, presence: true
  validates :customer_locality, presence: true
  validates :customer_country, presence: true
  validates :line_items, presence: true


  def country_name
    nation = ISO3166::Country[customer_country]
    nation.translations[I18n.locale.to_s] || nation.name
  end

end
