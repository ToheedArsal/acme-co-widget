module AcmeWidgetCo
  class DeliveryRules
    Rule = Struct.new(:limit_cents, :fee_cents, keyword_init: true)

    def initialize(rules)
      @rules = rules.map { |rule| build_rule(rule) }
      @rules.sort_by!(&:limit_cents)
    end

    def fee_for(subtotal_cents)
      rule = @rules.find { |r| subtotal_cents < r.limit_cents }
      (rule || default_rule).fee_cents
    end

    private

    def build_rule(rule)
      limit = normalize_limit(rule.fetch(:limit_cents))
      fee = Integer(rule.fetch(:fee_cents))
      Rule.new(limit_cents: limit, fee_cents: fee)
    end

    def normalize_limit(limit)
      return Float::INFINITY if limit == Float::INFINITY

      Integer(limit)
    end

    def default_rule
      @rules.last || Rule.new(limit_cents: Float::INFINITY, fee_cents: 0)
    end
  end
end

