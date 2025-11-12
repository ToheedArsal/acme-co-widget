require_relative "acme_widget_co/catalog"
require_relative "acme_widget_co/delivery_rules"
require_relative "acme_widget_co/offers/buy_one_get_second_half"
require_relative "acme_widget_co/basket"

module AcmeWidgetCo
  DEFAULT_PRODUCTS = {
    "R01" => { name: "Red Widget", price: 32.95 },
    "G01" => { name: "Green Widget", price: 24.95 },
    "B01" => { name: "Blue Widget", price: 7.95 }
  }.freeze

  DELIVERY_RULES_CONFIG = [
    { limit_cents: 5_000, fee_cents: 495 },
    { limit_cents: 9_000, fee_cents: 295 },
    { limit_cents: Float::INFINITY, fee_cents: 0 }
  ].freeze

  def self.create_basket(catalog: nil, delivery_rules: nil, offers: nil)
    Basket.new(
      catalog: catalog || default_catalog,
      delivery_rules: delivery_rules || default_delivery_rules,
      offers: offers || default_offers
    )
  end

  def self.default_catalog
    Catalog.new(DEFAULT_PRODUCTS)
  end

  def self.default_delivery_rules
    DeliveryRules.new(DELIVERY_RULES_CONFIG)
  end

  def self.default_offers
    [Offers::BuyOneGetSecondHalf.new("R01")]
  end
end

