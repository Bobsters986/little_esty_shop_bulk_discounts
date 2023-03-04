require 'rails_helper'

RSpec.describe 'Bulk Discounts Edit', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = @merchant1.bulk_discounts.create!(title: '20% off of 15 or more', percentage_discount: 20, quantity_threshold: 15)

    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
  end

  describe "As a merchant" do
    describe "when I visit my bulk discount edit page" do
      it 'I see that the discounts current attributes are pre-poluated in the form' do
        within 'div#discount_form' do
          expect(page).to have_field('Title', with: '20% off of 15 or more')
          expect(page).to have_field('Percentage Discount', with: 20)
          expect(page).to have_field('Quantity Threshold', with: 15)
        end
      end

      it "When I change any/all of the information and click submit, I am redirected to the bulk discount's show page" do
        within 'div#discount_form' do
          fill_in 'Title', with: '27% off of 21 or more'
          fill_in 'Percentage Discount', with: 27
          fill_in 'Quantity Threshold', with: 21
          click_button 'Submit'
        end

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
        expect(page).to have_content('Discount was successfully updated!')
        within 'div#discount_info' do
          expect(page).to have_content("Title: 27% off of 21 or more")
          expect(page).to have_content("Percentage Discount: 27%")
          expect(page).to have_content("Quantity Threshold: 21 items")
        end
      end

      it 'when I fill in a field with a letter where it should be a number, or leave a field blank, I am redirected back to the edit page and shown the errors' do
        
        within 'div#discount_form' do
          fill_in 'Title', with: ' '
          fill_in 'Percentage Discount', with: "hello"
          fill_in 'Quantity Threshold', with: ' '
          click_button 'Submit'
        end

        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Quantity threshold can't be blank")
        expect(page).to have_content("Quantity threshold is not a number")
        expect(page).to have_content("Percentage discount is not a number")
      end
    end
  end
end