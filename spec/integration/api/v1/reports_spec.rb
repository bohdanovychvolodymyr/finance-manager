require 'swagger_helper'

RSpec.describe 'API V1 Reports', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/api/v1/reports/monthly_expenses' do
    get 'Monthly expenses' do
      tags 'Reports'
      produces 'application/json'
      parameter name: :year, in: :query, type: :integer, required: true
      parameter name: :month, in: :query, type: :integer, required: true

      response '200', 'monthly expenses' do
        schema type: :array, items: {
          type: :object,
          properties: {
            category_id: { type: :integer },
            category_name: { type: :string },
            total: { type: :string }
          },
          required: %w[category_id category_name total]
        }

        let!(:cat) { Category.create!(name: "Groceries-#{SecureRandom.hex(4)}") }
        let!(:t1) { Transaction.create!(category: cat, amount: 10.0, kind: 'expense', occurred_at: Date.new(2026, 2, 5)) }
        let!(:t2) { Transaction.create!(category: cat, amount: 5.0, kind: 'expense', occurred_at: Date.new(2026, 2, 15)) }
        let(:year) { 2026 }
        let(:month) { 2 }
        run_test!
      end

      response '400', 'bad request' do
        let(:year) { 0 }
        let(:month) { 0 }
        run_test!
      end
    end
  end

  path '/api/v1/reports/daily_expenses' do
    get 'Daily expenses' do
      tags 'Reports'
      produces 'application/json'
      parameter name: :year, in: :query, type: :integer, required: true
      parameter name: :month, in: :query, type: :integer, required: true

      response '200', 'daily expenses' do
        schema type: :array, items: {
          type: :object,
          properties: {
            date: { type: :string },
            total: { type: :string }
          },
          required: %w[date total]
        }

        let!(:cat) { Category.create!(name: "Groceries-#{SecureRandom.hex(4)}") }
        let!(:t1) { Transaction.create!(category: cat, amount: 10.0, kind: 'expense', occurred_at: Date.new(2026, 2, 5)) }
        let!(:t2) { Transaction.create!(category: cat, amount: 5.0, kind: 'expense', occurred_at: Date.new(2026, 2, 5)) }
        let(:year) { 2026 }
        let(:month) { 2 }
        run_test!
      end

      response '400', 'bad request' do
        let(:year) { nil }
        let(:month) { nil }
        run_test!
      end
    end
  end
end
