module Spree
  class StockUpdaterMailer < BaseMailer
    def update_admin(errors, stock_updater)
      attachments['stock_items.csv'] = File.read(stock_updater.data_file.path)
      @errors = errors
      subject = "#{Spree::Store.current.name} : Failed Rows While Stock Updation"
      mail(to: ADMIN_EMAIL, from: from_address, subject: subject)
    end
  end
end
