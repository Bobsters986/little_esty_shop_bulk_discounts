require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    it "#total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe '#total_discounts data' do
      before(:each) do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Jewelry')

        @bulk_discount_1 = @merchant1.bulk_discounts.create!(title: '15% off of 10 or more', percentage_discount: 15, quantity_threshold: 10)
        @bulk_discount_2 = @merchant1.bulk_discounts.create!(title: '10% off of 5 or more', percentage_discount: 10, quantity_threshold: 5)

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
        @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
        @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

        @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
        @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
        @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
        @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
        @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
        @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
        @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
        @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
        @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
        @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
        @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)
        @invoice_9 = Invoice.create!(customer_id: @customer_2.id, status: 2)

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
        @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
        @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
        @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
        @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
        @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2, created_at: "2012-04-04 14:54:09")
        @ii_12 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_2.id, quantity: 8, unit_price: 20, status: 2, created_at: "2012-04-04 14:54:09")
        @ii_13 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_3.id, quantity: 12, unit_price: 30, status: 2, created_at: "2012-04-04 14:54:09")
        @ii_13 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_4.id, quantity: 6, unit_price: 10, status: 2, created_at: "2012-04-04 14:54:09")
        @ii_14 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_6.id, quantity: 6, unit_price: 10, status: 2, created_at: "2012-04-04 14:54:09")
      end

      it "#total_discounts" do
        expect(@invoice_9.total_discounts).to eq(91)
        expect(@invoice_9.total_discounts).to_not eq(97)
        expect(@invoice_9.total_revenue).to eq(740)

        InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_5.id, quantity: 12, unit_price: 10, status: 2, created_at: "2012-04-04 14:54:09")
        
        expect(@invoice_9.total_discounts).to eq(91)
        expect(@invoice_9.total_revenue).to eq(860)
      end

      it 'discounted_revenue' do
        expect(@invoice_9.total_revenue).to eq(740)
        expect(@invoice_9.discounted_revenue).to eq(649)

        @bulk_discount_2 = @merchant2.bulk_discounts.create!(title: '10% off of 5 or more', percentage_discount: 10, quantity_threshold: 5)
        #create new bulk discount to be applied to ii_14/item_6 above. Applies 10% discount, thus decreasing the discounted revenue by 6

        expect(@invoice_9.discounted_revenue).to eq(643)
        expect(@invoice_9.total_revenue).to eq(740)
      end
    end
  end
end
