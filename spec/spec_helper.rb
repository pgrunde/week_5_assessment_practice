require "user_database"
require "capybara/rspec"
require "./app"

Capybara.app = App

feature "Homepage" do
  scenario "Visit homepage" do
    visit "/"

    expect(page).to have_content("Register")
  end
  scenario "View register page" do
    visit "/"

    click_link "Register"

    expect(page).to have_content("Username")
  end
  scenario "Create a log in" do
    visit "/register/"

    fill_in("username", :with => "pgrunde")
    fill_in("password", :with => "password")

    click_button "Sign Up"

    expect(page).to have_content("Thank you for registering.")
  end
  scenario "Create log in and log in" do
    visit "/register/"

    fill_in("username", :with => "pgrunde")
    fill_in("password", :with => "password")

    click_button "Sign Up"

    fill_in("username", :with => "pgrunde")
    fill_in("password", :with => "password")

    click_button "Log In"

    expect(page).to have_content("Logout")
  end
  scenario "create log in and then log out" do
    visit "/register/"

    fill_in("username", :with => "pgrunde")
    fill_in("password", :with => "password")

    click_button "Sign Up"

    fill_in("username", :with => "pgrunde")
    fill_in("password", :with => "password")

    click_button "Log In"
    click_link "Logout"

    expect(page).to have_content("Register")
  end
end