# Acme Widget Co Basket

Proof of concept shopping basket for Acme Widget Co, implemented in Ruby 3.3.

## Prerequisites

- Ruby 3.3.0
- Bundler (`gem install bundler`)

## Setup

```bash
bundle install
```

## Running the Tests

```bash
bundle exec rspec
```

## Usage

Run the demo script with product codes:

```bash
ruby main.rb B01 G01
```

Or interact with the library directly:

```ruby
require "acme_widget_co"

catalog = AcmeWidgetCo.default_catalog
delivery_rules = AcmeWidgetCo.default_delivery_rules
offers = AcmeWidgetCo.default_offers

basket = AcmeWidgetCo::Basket.new(
  catalog: catalog,
  delivery_rules: delivery_rules,
  offers: offers
)

basket.add("B01")
basket.add("G01")

puts basket.total # => "$37.85"
```

### Customising the Basket

- **Products:** Provide your own `AcmeWidgetCo::Catalog` with product definitions (price can be passed as dollars or cents).
- **Delivery charges:** Instantiate `AcmeWidgetCo::DeliveryRules` with your own thresholds and fees (specified in cents).
- **Offers:** Add additional offer objects responding to `discount_for(items, catalog)` and returning the discount amount in cents.

## Extending Offers

To add a new offer, follow these steps:

### Step 1: Create the Offer Class

Create a new file in `lib/acme_widget_co/offers/` with your offer class. The class must:
- Be placed in the `AcmeWidgetCo::Offers` module
- Implement a `discount_for(items, catalog)` method that returns the discount amount in cents

**Example:** Creating a "Buy 3, Get 1 Free" offer for Blue Widgets

```ruby
# lib/acme_widget_co/offers/buy_three_get_one_free.rb
module AcmeWidgetCo
  module Offers
    class BuyThreeGetOneFree
      def initialize(product_code)
        @product_code = product_code
      end

      def discount_for(items, catalog)
        count = items.count { |code| code == @product_code }
        return 0 if count < 3

        product = catalog.fetch(@product_code)
        free_count = count / 3
        free_count * product.price_cents
      end
    end
  end
end
```

### Step 2: Require the New Offer

Add a require statement in `lib/acme_widget_co.rb`:

```ruby
require_relative "acme_widget_co/offers/buy_three_get_one_free"
```

### Step 3: Use the New Offer

You can use your new offer in two ways:

**Option A: Add to default offers**

Modify `AcmeWidgetCo.default_offers` in `lib/acme_widget_co.rb`:

```ruby
def self.default_offers
  [
    Offers::BuyOneGetSecondHalf.new("R01"),
    Offers::BuyThreeGetOneFree.new("B01")
  ]
end
```

**Option B: Pass offers when creating a basket**

```ruby
require "acme_widget_co"

offers = [
  AcmeWidgetCo::Offers::BuyOneGetSecondHalf.new("R01"),
  AcmeWidgetCo::Offers::BuyThreeGetOneFree.new("B01")
]

basket = AcmeWidgetCo::Basket.new(
  catalog: AcmeWidgetCo.default_catalog,
  delivery_rules: AcmeWidgetCo.default_delivery_rules,
  offers: offers
)
```

### Offer Interface

All offer classes must implement:

- **`discount_for(items, catalog)`** - Returns the total discount amount in cents
  - `items`: Array of product codes (duplicated, so safe to modify)
  - `catalog`: `AcmeWidgetCo::Catalog` instance to fetch product details
  - Returns: Integer representing discount in cents

The basket will sum all discounts from all offers before calculating the final total.

## Assumptions

- Delivery fees are calculated after applying discounts.
- Monetary values are handled in cents to avoid floating point errors.
- The “buy one red widget, get the second half price” offer rounds half-price up to the nearest cent, matching the expected totals.

## Expected Totals

| Products                     | Total   |
|-----------------------------|---------|
| `B01`, `G01`                | $37.85  |
| `R01`, `R01`                | $54.37  |
| `R01`, `G01`                | $60.85  |
| `B01`, `B01`, `R01`, `R01`, `R01` | $98.27  |
