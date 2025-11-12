#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require "acme_widget_co"

basket = AcmeWidgetCo.create_basket

ARGV.each { |code| basket.add(code) }

if ARGV.empty?
  puts "Usage: ruby main.rb PRODUCT_CODE [PRODUCT_CODE ...]"
  puts "Example: ruby main.rb B01 G01"
  exit 1
end

puts "Items: #{ARGV.join(', ')}"
puts "Total: #{basket.total}"
