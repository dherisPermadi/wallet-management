require "application_system_test_case"

class MoneyTransactionsTest < ApplicationSystemTestCase
  setup do
    @money_transaction = money_transactions(:one)
  end

  test "visiting the index" do
    visit money_transactions_url
    assert_selector "h1", text: "MoneyTransactions"
  end

  test "should create wallet money_transaction" do
    visit money_transactions_url
    click_on "New wallet money_transaction"

    click_on "Create MoneyTransaction"

    assert_text "MoneyTransaction was successfully created"
    click_on "Back"
  end

  test "should update MoneyTransaction" do
    visit money_transaction_url(@money_transaction)
    click_on "Edit this wallet money_transaction", match: :first

    click_on "Update MoneyTransaction"

    assert_text "MoneyTransaction was successfully updated"
    click_on "Back"
  end

  test "should destroy MoneyTransaction" do
    visit money_transaction_url(@money_transaction)
    click_on "Destroy this wallet money_transaction", match: :first

    assert_text "MoneyTransaction was successfully destroyed"
  end
end
