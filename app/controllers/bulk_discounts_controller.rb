class BulkDiscountsController < ApplicationController
  before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update]
  before_action :find_merchant, only: [:index, :new, :create, :destroy]

  def index
    # @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
  end

  def edit
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    discount = @merchant.bulk_discounts.create(bulk_discount_params)
    redirect_to (merchant_bulk_discounts_path(@merchant))
  end

  def update
    if @discount.update(bulk_discount_params)
      flash[:success] = 'Discount was successfully updated!'
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else
      flash[:error] = error_message(@discount.errors)
      redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
    end
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    flash[:notice] = "Discount deleted"
    redirect_to (merchant_bulk_discounts_path(@merchant))
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount_and_merchant
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:title, :percentage_discount, :quantity_threshold)
  end
end