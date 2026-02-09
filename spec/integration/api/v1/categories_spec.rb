require 'swagger_helper'

RSpec.describe 'API V1 Categories', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/api/v1/categories' do
    get 'List categories' do
      tags 'Categories'
      produces 'application/json'

      response '200', 'categories found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string, nullable: true },
            active: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: %w[id name active]
        }

        let!(:category) { Category.create!(name: "Groceries-#{SecureRandom.hex(4)}", description: 'Food and groceries') }
        run_test!
      end
    end

    post 'Create category' do
      tags 'Categories'
      consumes 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              active: { type: :boolean }
            },
            required: ['name']
          }
        }
      }

      response '201', 'category created' do
        let(:category) { { category: { name: 'Bills', description: 'Monthly', active: true } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:category) { { category: { description: 'no name' } } }
        run_test!
      end
    end
  end

  path '/api/v1/categories/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get category' do
      tags 'Categories'
      produces 'application/json'

      response '200', 'category found' do
        let(:id) { Category.create!(name: 'One').id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    patch 'Update category' do
      tags 'Categories'
      consumes 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              active: { type: :boolean }
            }
          }
        }
      }

      response '200', 'updated' do
        let(:id) { Category.create!(name: 'One').id }
        let(:category) { { category: { name: 'Updated Name' } } }
        run_test!
      end

      response '422', 'invalid' do
        let(:id) { Category.create!(name: 'One').id }
        let(:category) { { category: { name: '' } } }
        run_test!
      end
    end

    delete 'Delete category' do
      tags 'Categories'

      response '204', 'no content' do
        let(:id) { Category.create!(name: 'ToDelete').id }
        run_test!
      end
    end
  end
end
