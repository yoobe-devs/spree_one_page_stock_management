module Spree
  class StockUpdaterMailer < BaseMailer
    def update_admin(errors, stock_updater)
      attachments['stock_items.csv'] = File.read(stock_updater.data_file.path)
      @errors = errors
      subject = "#{Spree::Store.current.name} : Failed Rows While Stock Updation"
      mail(to: admin_email_notify_address, from: from_address, subject: subject)
    end

    private
      def admin_email_notify_address
        Spree::Config[:mail_to_address] || from_address
      end
  end
end
