module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show edit update destroy]

      def index
        @categories = Category.all
        render json: @categories
      end

      def show
        render json: @category
      end

      def new
        @category = Category.new
        render json: @category
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          render json: @category, status: :created
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        render json: @category
      end

      def update
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @category.destroy
        head :no_content
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :active)
      end
    end
  end
end
