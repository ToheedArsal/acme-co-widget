require "spec_helper"

RSpec.describe AcmeWidgetCo::Basket do
  subject(:basket) do
    described_class.new(
      catalog: catalog,
      delivery_rules: delivery_rules,
      offers: offers
    )
  end

  let(:catalog) { AcmeWidgetCo.default_catalog }
  let(:delivery_rules) { AcmeWidgetCo.default_delivery_rules }
  let(:offers) { AcmeWidgetCo.default_offers }

  describe "#add" do
    it "returns the basket to allow chaining" do
      expect(basket.add("B01")).to be(basket)
    end

    it "raises an error for an unknown product code" do
      expect { basket.add("UNKNOWN") }.to raise_error(ArgumentError)
    end
  end

  describe "#total" do
    {
      %w[B01 G01] => "$37.85",
      %w[R01 R01] => "$54.37",
      %w[R01 G01] => "$60.85",
      %w[B01 B01 R01 R01 R01] => "$98.27"
    }.each do |items, total|
      it "returns #{total} for #{items.join(', ')}" do
        items.each { |code| basket.add(code) }
        expect(basket.total).to eq(total)
      end
    end
  end
end

