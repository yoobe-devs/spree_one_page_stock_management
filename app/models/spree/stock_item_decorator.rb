Spree::StockItem.class_eval do
  self.whitelisted_ransackable_associations = ['variant']
end
