module AcmeWidgetCo
  module Offers
    class BuyOneGetSecondHalf
      def initialize(product_code)
        @product_code = product_code
      end

      def discount_for(items, catalog)
        count = items.count { |code| code == @product_code }
        return 0 if count < 2

        product = catalog.fetch(@product_code)
        pair_count = count / 2
        pair_count * half_price(product.price_cents)
      end

      private

      def half_price(price_cents)
        (price_cents / 2.0).round
      end
    end
  end
end

