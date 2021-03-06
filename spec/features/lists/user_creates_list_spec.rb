require 'rails_helper'

feature 'user creates list', %{
  As a user I should be able to create a list
} do

  before(:each) do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'user creates public list', js: true do

    visit new_list_path

    fill_in "Title", with: "Test list"
    # handles toggling "Public" option on form
    find('label', text: 'No').click


    click_button "Create List"

    expect(page).to have_content("Created List Successfully.")
    expect(page).to have_content("Test List")

    visit lists_path

    expect(page).to have_content('Test List')
  end

  scenario 'user creates private list' do

    visit new_list_path

    fill_in "Title", with: "Test list"
    #when creating a list it defaults to public being unchecked

    click_button "Create List"

    expect(page).to have_content("Created List Successfully.")
    expect(page).to have_content("Test List")
    expect(page).to have_content("No Due Date")

    visit lists_path

    expect(page).not_to have_content('Test List')
  end

  scenario 'user creates list with due date', js: true do

    date = (DateTime.now + 36.hours).to_s

    visit new_list_path

    fill_in "Title", with: "Test list"
    #server reads due date params from a hidden input field
    #simulate user picking datetime
    execute_script("$('#js-list-due-date')[0].value = '#{date}';")
    #when creating a list it defaults to public being unchecked

    click_button "Create List"

    expect(page).to have_content("Created List Successfully.")
    expect(page).to have_content("Test List")
    expect(page).to have_content("1 day")

    visit lists_path

    expect(page).not_to have_content('Test List')
  end
end
