require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category1 = categories(:one)
    @category2 = categories(:two)
  end

  test "monthly expenses grouped by category" do
    get api_v1_reports_monthly_expenses_url(year: 2026, month: 2, format: :json)
    assert_response :success

    data = JSON.parse(response.body)

    assert_equal 2, data.length

    groceries = data.find { |d| d["category_name"] == @category1.name }
    assert groceries
    assert_equal "32.34", groceries["total"]

    utilities = data.find { |d| d["category_name"] == @category2.name }
    assert utilities
    assert_equal "5.66", utilities["total"]
  end

  test "daily expenses for a month" do
    get api_v1_reports_daily_expenses_url(year: 2026, month: 2, format: :json)
    assert_response :success

    data = JSON.parse(response.body)

    day1 = data.find { |d| d["date"] == "2026-02-05" }
    day2 = data.find { |d| d["date"] == "2026-02-10" }

    assert day1
    assert_in_delta 18.0, day1["total"].to_f, 0.001

    assert day2
    assert_in_delta 20.0, day2["total"].to_f, 0.001
  end

  test "bad params return 400" do
    get api_v1_reports_monthly_expenses_url(year: 0, month: 0, format: :json)
    assert_response :bad_request

    get api_v1_reports_daily_expenses_url(year: nil, month: nil, format: :json)
    assert_response :bad_request
  end
end
