class Sale < ApplicationRecord
  belongs_to :user

  def country_name
    nation = ISO3166::Country[customer_country]
    nation.translations[I18n.locale.to_s] || nation.name
  end

end
