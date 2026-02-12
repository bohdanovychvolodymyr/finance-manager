# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# A small, deterministic seed to exercise /api/v1/reports/monthly_expenses

Category.find_or_create_by!(name: 'Food')
Category.find_or_create_by!(name: 'Transport')
Category.find_or_create_by!(name: 'Shopping')
Category.find_or_create_by!(name: 'Income')

def find_category(name)
  Category.find_by!(name: name)
end

# February 2026 expenses
Transaction.find_or_create_by!(description: 'Coffee', occurred_at: Date.new(2026, 2, 5)) do |t|
  t.category = find_category('Food')
  t.amount = 12.34
  t.kind = :expense
end

Transaction.find_or_create_by!(description: 'Bus', occurred_at: Date.new(2026, 2, 5)) do |t|
  t.category = find_category('Transport')
  t.amount = 5.66
  t.kind = :expense
end

Transaction.find_or_create_by!(description: 'Weekly shopping', occurred_at: Date.new(2026, 2, 10)) do |t|
  t.category = find_category('Shopping')
  t.amount = 20.00
  t.kind = :expense
end

# A March expense so date filtering can be observed
Transaction.find_or_create_by!(description: 'March expense', occurred_at: Date.new(2026, 3, 10)) do |t|
  t.category = find_category('Food')
  t.amount = 100.00
  t.kind = :expense
end

# An income record (should not be included in expense reports)
Transaction.find_or_create_by!(description: 'Salary', occurred_at: Date.new(2026, 2, 28)) do |t|
  t.category = find_category('Income')
  t.amount = 1000.00
  t.kind = :income
end
