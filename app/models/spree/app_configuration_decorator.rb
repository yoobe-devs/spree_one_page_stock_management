Spree::AppConfiguration.class_eval do
  preference :stock_items_per_page, :integer, default: 15
end
