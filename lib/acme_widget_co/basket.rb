require_relative "catalog"
require_relative "delivery_rules"

module AcmeWidgetCo
  class Basket
    def initialize(catalog:, delivery_rules:, offers: [])
      @catalog = catalog
      @delivery_rules = delivery_rules
      @offers = offers
      @items = []
    end

    def add(code)
      @items << @catalog.fetch(code).code
      self
    end

    def total
      discounted_subtotal = subtotal_cents - discount_cents
      delivery_fee = @delivery_rules.fee_for(discounted_subtotal)
      cents_to_currency(discounted_subtotal + delivery_fee)
    end

    private

    def subtotal_cents
      @items.sum { |code| @catalog.fetch(code).price_cents }
    end

    def discount_cents
      @offers.sum { |offer| offer.discount_for(@items.dup, @catalog) }
    end

    def cents_to_currency(cents)
      format("$%.2f", cents.to_i / 100.0)
    end
  end
end

