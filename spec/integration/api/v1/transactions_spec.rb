require 'swagger_helper'

RSpec.describe 'API V1 Transactions', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/api/v1/transactions' do
    get 'List transactions' do
      tags 'Transactions'
      produces 'application/json'

      response '200', 'transactions found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            category_id: { type: :integer },
            amount: { type: :string },
            kind: { type: :integer },
            description: { type: :string, nullable: true },
            occurred_at: { type: :string, format: 'date' }
          },
          required: %w[id category_id amount kind occurred_at]
        }

        let!(:category) { Category.create!(name: "Groceries-#{SecureRandom.hex(4)}") }
        let!(:transaction) { Transaction.create!(category: category, amount: 12.34, kind: 'expense', occurred_at: Date.today) }
        run_test!
      end
    end

    post 'Create transaction' do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              category_id: { type: :integer },
              amount: { type: :number, format: :float },
              kind: { type: :string },
              description: { type: :string },
              occurred_at: { type: :string, format: 'date' }
            },
            required: ['category_id', 'amount', 'kind', 'occurred_at']
          }
        }
      }

      response '201', 'transaction created' do
        let(:category) { Category.create!(name: 'Bills') }
        let(:transaction) { { transaction: { category_id: category.id, amount: 99.99, kind: 'income', occurred_at: '2026-02-06' } } }
        run_test!
      end

      response '422', 'invalid' do
        let(:transaction) { { transaction: { category_id: nil } } }
        run_test!
      end
    end
  end

  path '/api/v1/transactions/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get transaction' do
      tags 'Transactions'
      produces 'application/json'

      response '200', 'transaction found' do
        let(:id) { Category.create!(name: 'A'); Transaction.create!(category: Category.first, amount: 1.23, kind: 'expense', occurred_at: Date.today).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    patch 'Update transaction' do
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              category_id: { type: :integer },
              amount: { type: :number, format: :float },
              kind: { type: :string },
              description: { type: :string },
              occurred_at: { type: :string, format: 'date' }
            }
          }
        }
      }

      response '200', 'updated' do
        let!(:category) { Category.create!(name: 'C') }
        let(:id) { Transaction.create!(category: category, amount: 5.0, kind: 'expense', occurred_at: Date.today).id }
        let(:transaction) { { transaction: { amount: 15.0 } } }
        run_test!
      end

      response '422', 'invalid' do
        let!(:category) { Category.create!(name: 'D') }
        let(:id) { Transaction.create!(category: category, amount: 5.0, kind: 'expense', occurred_at: Date.today).id }
        let(:transaction) { { transaction: { amount: nil } } }
        run_test!
      end
    end

    delete 'Delete transaction' do
      tags 'Transactions'

      response '204', 'no content' do
        let!(:category) { Category.create!(name: 'E') }
        let(:id) { Transaction.create!(category: category, amount: 4.0, kind: 'expense', occurred_at: Date.today).id }
        run_test!
      end
    end
  end
end
