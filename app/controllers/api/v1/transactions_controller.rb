module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_transaction, only: %i[show edit update destroy]

      def index
        @transactions = Transaction.all
        render json: @transactions
      end

      def show
        render json: @transaction
      end

      def new
        @transaction = Transaction.new
        render json: @transaction
      end

      def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        render json: @transaction
      end

      def update
        if @transaction.update(transaction_params)
          render json: @transaction, status: :ok
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @transaction.destroy
        head :no_content
      end

      private

      def set_transaction
        @transaction = Transaction.find(params[:id])
      end

      def transaction_params
        params.require(:transaction).permit(:category_id, :amount, :kind, :description, :occurred_at)
      end
    end
  end
end
