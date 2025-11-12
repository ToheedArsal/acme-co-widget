module AcmeWidgetCo
  Product = Struct.new(:code, :name, :price_cents, keyword_init: true)

  class Catalog
    def initialize(products)
      @products = {}

      products.each do |code, attributes|
        @products[code] = build_product(code, attributes)
      end
    end

    def fetch(code)
      product = @products[code]
      raise ArgumentError, "Unknown product code: #{code}" unless product

      product
    end

    private

    def build_product(code, attributes)
      return attributes if attributes.is_a?(Product)

      name = attributes.fetch(:name)
      price_in = attributes.fetch(:price)
      price_cents = to_cents(price_in)

      Product.new(code: code, name: name, price_cents: price_cents)
    end

    def to_cents(price)
      if price.is_a?(Integer)
        price
      else
        (Float(price) * 100).round
      end
    end
  end
end

