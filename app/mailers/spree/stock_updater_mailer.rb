module Spree
  class StockUpdaterMailer < BaseMailer
    def update_admin(errors)
      @errors = errors
      subject = "#{Spree::Store.current.name} : Failed Rows While Stock Updation"
      mail(to: ADMIN_EMAIL, from: 'himanshumishra3@gmail.com', subject: subject)
    end
  end
end
