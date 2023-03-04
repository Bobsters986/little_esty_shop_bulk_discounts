class BulkDiscountsController < ApplicationController
  # before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    # @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    discount = @merchant.bulk_discounts.create(bulk_discount_params)
    redirect_to (merchant_bulk_discounts_path(@merchant))
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:title, :percentage_discount, :quantity_threshold)
  end
end