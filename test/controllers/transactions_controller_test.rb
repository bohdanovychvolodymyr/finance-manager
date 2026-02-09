require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = transactions(:one)
    @category = categories(:one)
  end

  test "should get index" do
    get api_v1_transactions_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert body.is_a?(Array)
  end

  test "should show transaction" do
    get api_v1_transaction_url(@transaction, format: :json)
    assert_response :success
    data = JSON.parse(response.body)
    assert_equal @transaction.amount.to_s, data["amount" ]
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post api_v1_transactions_url(format: :json), params: { transaction: { category_id: @category.id, amount: 99.99, kind: :income, occurred_at: "2026-02-06" } }
    end
    assert_response :created
    data = JSON.parse(response.body)
    assert_equal "99.99", data["amount"]
  end

  test "should not create invalid transaction" do
    assert_no_difference("Transaction.count") do
      post api_v1_transactions_url(format: :json), params: { transaction: { category_id: @category.id } }
    end
    assert_response :unprocessable_entity
  end

  test "should update transaction" do
    patch api_v1_transaction_url(@transaction, format: :json), params: { transaction: { amount: 55.50 } }
    assert_response :success
    @transaction.reload
    assert_equal BigDecimal("55.5"), @transaction.amount
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete api_v1_transaction_url(@transaction, format: :json)
    end
    assert_response :no_content
  end
end
