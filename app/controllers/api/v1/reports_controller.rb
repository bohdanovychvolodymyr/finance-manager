module Api
  module V1
    class ReportsController < ApplicationController
      def monthly_expenses
        year = params[:year].to_i
        month = params[:month].to_i
        return head :bad_request if year <= 0 || month <= 0

        start_date = Date.new(year, month, 1)
        end_date = start_date.end_of_month

        sums = Transaction.where(kind: Transaction::KINDS[:expense], occurred_at: start_date..end_date)
                      .joins(:category)
                      .group('categories.id', 'categories.name')
                      .sum(:amount)

        result = sums.map do |(id, name), total|
          { category_id: id, category_name: name, total: sprintf('%.2f', total.to_f) }
        end

        render json: result
      end

      # GET /reports/daily_expenses?year=2026&month=2
      def daily_expenses
        year = params[:year].to_i
        month = params[:month].to_i
        return head :bad_request if year <= 0 || month <= 0

        start_date = Date.new(year, month, 1)
        end_date = start_date.end_of_month

        sums = Transaction.where(kind: Transaction::KINDS[:expense], occurred_at: start_date..end_date)
                      .group(:occurred_at)
                      .sum(:amount)

        result = sums.map do |date, total|
          { date: date.to_s, total: sprintf('%.2f', total.to_f) }
        end

        render json: result
      end
    end
  end
end
