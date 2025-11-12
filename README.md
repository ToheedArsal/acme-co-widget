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
