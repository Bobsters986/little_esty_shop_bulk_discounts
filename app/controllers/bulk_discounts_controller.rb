class BulkDiscountsController < ApplicationController
  # before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:index]

  def index
    # @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end


  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end