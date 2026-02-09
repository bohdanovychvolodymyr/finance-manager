require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "valid with attributes" do
    t = Transaction.new(category: categories(:one), amount: 10.0, kind: :expense, occurred_at: Date.today)
    assert t.valid?
  end

  test "invalid without amount" do
    t = Transaction.new(category: categories(:one), kind: :income, occurred_at: Date.today)
    refute t.valid?
    assert_includes t.errors[:amount], "can't be blank"
  end

  test "enum kinds are defined" do
    assert Transaction.kinds.key?('expense')
    assert Transaction.kinds.key?('income')
    assert Transaction.kinds.key?('transfer')
  end
end
