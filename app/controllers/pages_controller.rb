class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    recent_sales = Sale.all.limit(10).order("id DESC")
    @sale = recent_sales.sample

    # sampled_line_item = JSON.parse @sale.line_items.sample.gsub('=>', ':')
    # @line_item_name = sampled_line_item["name"]
  end
end
