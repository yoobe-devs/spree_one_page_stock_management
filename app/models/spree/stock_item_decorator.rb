require 'csv'

Spree::StockItem.class_eval do
  self.whitelisted_ransackable_associations = ['variant']

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      stock_item = Spree::StockItem.find_by(variant_id: row['variant_id'], stock_location_id: row['stock_location_id'])
      if stock_item
        backorderable = row['backorderable'] == 'true' ? true : false
        stock_item.update_columns(count_on_hand: row['count_on_hand'], backorderable: backorderable)
      end
    end
  end
end
