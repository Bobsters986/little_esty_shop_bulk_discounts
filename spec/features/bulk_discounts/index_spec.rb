require 'rails_helper'

RSpec.describe 'Bulk Discounts Index', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @bulk_discount_1 = @merchant1.bulk_discounts.create!(title: '20% off of 15 or more', percentage_discount: 0.2, quantity_threshold: 15)
    @bulk_discount_2 = @merchant1.bulk_discounts.create!(title: '15% off of 10 or more', percentage_discount: 0.15, quantity_threshold: 10)

    @bulk_discount_3 = @merchant2.bulk_discounts.create!(title: '25% off of 15 or more', percentage_discount: 0.25, quantity_threshold: 15)

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

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)

    visit merchant_bulk_discounts_path(@merchant1.id)
  end

  describe "As a merchant" do
    describe "when I visit my bulk discounts index page" do
      it 'I see all of my bulk discounts including their percentage discount and quantity thresholds' do
        within 'section#all_discounts' do
          expect(page).to have_content("Title: #{@bulk_discount_1.title}")
          expect(page).to have_content("Percentage Discount: #{(@bulk_discount_1.percentage_discount * 100).to_i}%")
          expect(page).to have_content("Quantity Threshold: #{@bulk_discount_1.quantity_threshold} items")
          expect(page).to have_content("Title: #{@bulk_discount_2.title}")
          expect(page).to have_content("Percentage Discount: #{(@bulk_discount_2.percentage_discount * 100).to_i}%")
          expect(page).to have_content("Quantity Threshold: #{@bulk_discount_2.quantity_threshold} items")

          expect(page).to_not have_content("Title: #{@bulk_discount_3.title}")
        end
      end

      it 'I see each bulk discount listed includes a link to its show page' do
        within 'section#all_discounts' do
          expect(page).to have_link(@bulk_discount_1.title)
          expect(page).to have_link(@bulk_discount_2.title)

          expect(page).to_not have_link(@bulk_discount_3.title)
        end
      end

      it 'I see a link to create a new discount' do
        expect(page).to have_link("Create New Discount")
      end

      it 'when I click the link, it takes me to a new page where I see a form to add a new bulk discount' do
        click_link "Create New Discount"
        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
        fill_in "Title", with: "25% off of 25 or more"
        fill_in "Percentage Discount", with: ".25"
        fill_in "Quantity Threshold", with: "25"
        click_button "Submit"

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
        within 'section#all_discounts' do
          expect(page).to have_content("Title: 25% off of 25 or more")
          expect(page).to have_content("Percentage Discount: 25%")
          expect(page).to have_content("Quantity Threshold: 25")
        end
      end

      it 'Then next to each bulk discount I see a link to delete it' do
        within 'section#all_discounts' do
          expect(page).to have_link("Delete #{@bulk_discount_1.title}")
          expect(page).to have_link("Delete #{@bulk_discount_2.title}")
        end
      end

      it 'When I click the delete link, I am redirected back to the bulk discounts index page, and I no longer see the discount listed' do
        click_link "Delete #{@bulk_discount_1.title}"

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

        expect(page).to have_content("Discount deleted")
        expect(page).to_not have_content("Title: #{@bulk_discount_1.title}")
        expect(page).to_not have_content("Percentage Discount: #{(@bulk_discount_1.percentage_discount * 100).to_i}%")
        expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount_1.quantity_threshold} items")
      end
    end
  end
end