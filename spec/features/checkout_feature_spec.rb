require "rails_helper"
require "support/address_helpers"
require "support/checkout_helpers"

include AddressHelpers
include CheckoutHelpers

RSpec.describe "Checkout Feature", type: :feature do
  before(:all) do
    create_list(:product, 5)
    @user = create(:regular_user)
  end

  after(:all) { DatabaseCleaner.clean_with(:truncation) }

  before(:each) do
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(@user)
  end

  it "adds products successfully", js: true do
    add_products_and_checkout
    fill_in_address
    click_button "Save and Continue"
    click_button "Proceed to Payment"
    click_button "Complete Order"
    expect(page).to have_content("Thank you!")
  end

  it "checks out with paypal successfully", js: true do
    page.driver.browser.manage.window.resize_to(1280, 600)
    add_products_and_checkout
    fill_in_address
    click_button "Save and Continue"
    click_button "Proceed to Payment"
    click_on "Pay with Paypal"
    click_button "Proceed to Paypal"
    expect(current_url).to have_content("paypal")
  end
end