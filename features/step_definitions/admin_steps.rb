require 'pry'

Then(/^I should see the add user form$/) do
  expect( page ).to have_css 'form#new_user'
end

When(/^I choose a "(.*?)" role$/) do |role|
  select role, from: 'user_role'
end

Then(/^I should not see the PCMO select box$/) do
  !find_field('user_pcmo_id').visible?
end

When(/^I choose the user country "(.*?)"$/) do |name|
  select name, from: 'user_country_id'
end

When(/^I unselect the user country$/) do
  select 'Country', from: 'user_country_id'
end

Then(/^I should see the PCMO select box$/) do
  find_field('user_pcmo_id').visible?
end

When(/^I should be able to select from PCMOs in "(.*?)"$/) do |name|
  # There ought to be a better capybara built-in for checking for the presence
  # of a select box with an exact set of values, but has_select? doesn't seem
  # to be working

  # This might help: http://makandracards.com/makandra/6505-issues-with-has_select

  local_pcmos = Set.new Country.where(name: name).first!.users.pcmos.pluck :id
  options = page.all('#user_pcmo_id optgroup option').reduce(Set.new) do |s,o|
    s << o.native[:value].to_i
    s
  end

  expect( local_pcmos ).to eq options
end

When(/^I fill out the add user form$/) do
  fill_in "First Name",         with: @visitor[:first_name]
  fill_in "Last Name",          with: @visitor[:last_name]
  fill_in "Address / location", with: "Roswell"
  fill_in "PCV ID",             with: "11111111"
  fill_in "Email",              with: @visitor[:email]

  select  "Chad",                  from: 'user_country_id'
  select  "Peace Corps Volunteer", from: 'user_role'
end

When(/^I click "(.*?)"$/) do |name|
  click_button name
end

Then(/^I should see a "(.*?)" confirmation$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a no_change confirmation$/) do
  #AL: page.should have_selector ".modal-body", text: 'No changes made'
  pos_ack_msg 'No changes made'
end

When(/^I change (\w+) to (\w*)$/) do |field, value|
  if field == "user_country_id"
    select  value, from: field
  elsif field == "user_role"
    select  "Assign Role", from: field
  else
    fill_in field, with: value
  end
end

Then(/^I should see a (\w+) error message$/) do |type|
  #WAS: expect( page ).to have_css(".error", text: type)
  if type == "required"
    err_msg "can't be blank"
    err_msg "prohibited this user from being submitted:"
  elsif type == "invalid"
    err_msg "is invalid"
    err_msg "prohibited this user from being submitted:"
  elsif type == "unique"
    err_msg "has already been taken"
  else
    fail
  end
end

Then(/^I should see the edit account form$/) do
  expect( page ).to have_content('Edit Account')
end

When(/^I fill out the edit user form$/) do
  fill_in "First Name",         with: @visitor[:first_name]
  fill_in "Last Name",          with: @visitor[:last_name]
  fill_in "Address / location", with: "Roswell"
  fill_in "PCV ID",             with: "11111111"
  fill_in "Email",              with: @visitor[:email]

  select  "Chad",                  from: 'user_country_id'
  select  "Peace Corps Volunteer", from: 'user_role'
end

When(/^I choose a "(.*?)" edit user$/) do |name|
  select "#{name} (#{User.find(1).pcv_id})", from: 'edit_user'
end

Then(/^I should see a required edit volunteer error message$/) do
  #AL: page.should have_selector ".modal-body", text: 'Please select a volunteer to edit.'
  err_msg 'Please select a volunteer to edit.'
end

Then(/^I should see a choose csv file first error message$/) do
  #AL: page.should have_selector ".modal-body", text: 'Please choose a csv file first.'
  err_msg 'Please choose a csv file first.'
end
#save_and_open_page
