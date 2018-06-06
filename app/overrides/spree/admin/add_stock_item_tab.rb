Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'add_stock_item_tab',
  insert_bottom: "[data-hook='admin_tabs']",
  text: %q{
      <% if can? :admin, Spree::StockItem %>
        <ul class="nav nav-sidebar">
          <%= tab *Spree::BackendConfiguration::STOCKS_TABS, icon: 'th-list' %>
        </ul>
      <% end %>
    }
)
