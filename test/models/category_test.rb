require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid with name" do
    c = Category.new(name: "Utilities")
    assert c.valid?
  end

  test "invalid without name" do
    c = Category.new
    refute c.valid?
    assert_includes c.errors[:name], "can't be blank"
  end
end
