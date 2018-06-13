require 'csv'

class NotifyFailedStocksService

  def initialize(stock_updater_id)
    @errors = Hash.new(Array.new())
    @stock_updater = Spree::StockUpdater.find_by(id: stock_updater_id)
    update_stocks
    @stock_updater.update_column(:job_executed, true)
    Spree::StockUpdaterMailer.update_admin(@errors, @stock_updater).deliver_now
    @stock_updater.destroy if @stock_updater.job_executed?
  end

  private
    def update_stocks
      CSV.foreach(@stock_updater.data_file.path, headers: true) do |row|
        @row = row
        find_variant_and_stock_location
        if @variant && @stock_location
          @stock_item = Spree::StockItem.find_by(variant_id: @variant.id, stock_location_id: @stock_location.id)
          update_stocks_with_csv_values
        else
          if @variant
            @errors['stock_location'] += [@row['stock_location_name']]
          else
            @errors['variant'] += [@row['uid']]
          end
        end
      end
    end

    def update_stocks_with_csv_values
      if @stock_item
        set_backorderable(@row['backorderable'].to_s.downcase)
        set_count_on_hand
        update_stock_item
      else
        @errors['stock_items'] += ["#{@row['uid']} and #{@row['stock_location_name']}"]
      end
    end

    def find_variant_and_stock_location
      @variant = Spree::Variant.find_by_sku(@row['uid'].to_s.upcase) || Spree::Variant.find_by_id(@row['uid'])
      @stock_location = Spree::StockLocation.find_by_name(@row['stock_location_name'])
    end

    def set_backorderable(csv_backorderable)
      if csv_backorderable == 'true'
        @backorderable = true
      elsif csv_backorderable == 'false'
        @backorderable = false
      else
        @backorderable = @stock_item.backorderable
      end
    end

    def set_count_on_hand
      @count_on_hand = @row['count_on_hand'].scan(/\D/).empty? ? @row['count_on_hand'] : @stock_item.count_on_hand
    end

    def update_stock_item
      @stock_item.update_columns(count_on_hand: @count_on_hand, backorderable: @backorderable)
    end
end
