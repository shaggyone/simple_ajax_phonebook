require 'spec_helper'

feature 'Phone book entries page', js: true do
  background do
    FactoryGirl.create :phone_book_entry, full_name: 'A', phone_number: '3124344'
    FactoryGirl.create :phone_book_entry, full_name: 'B', phone_number: '4213423'
    FactoryGirl.create :phone_book_entry, full_name: 'C', phone_number: '5342523'
    FactoryGirl.create :phone_book_entry, full_name: 'D', phone_number: '6236343'

    visit '/'
  end

  scenario 'User should see the phone book entries' do
    within "#PhoneBook" do
      page.should have_content 'Full name Phone number
                                A 3124344
                                B 4213423
                                C 5342523
                                D 6236343'
    end
  end

  context 'adding an entry' do
    scenario 'User adds an entry' do
      within '#PhoneBook' do
        fill_in 'phone_book_entry_full_name',    with: 'Victor'
        fill_in 'phone_book_entry_phone_number', with: '5346-4234'

        click_button 'Add entry'

        page.should have_content 'Full name Phone number
                                  A 3124344
                                  B 4213423
                                  C 5342523
                                  D 6236343
                                  Victor 5346-4234'
      end
    end

    scenario 'User forgets to add name' do
      within '#PhoneBook' do
        fill_in 'phone_book_entry_full_name',    with: ''
        fill_in 'phone_book_entry_phone_number', with: '5346-4234'

        click_button 'Add entry'

        page.should have_selector '#phone_book_entry_full_name.error'
        page.should_not have_selector '#phone_book_entry_phone_number.error'
      end
    end

    scenario 'User forgets to add phone_number' do
      within '#PhoneBook' do
        fill_in 'phone_book_entry_full_name',    with: 'Victor'
        fill_in 'phone_book_entry_phone_number', with: ''

        click_button 'Add entry'

        page.should have_selector '#phone_book_entry_phone_number.error'
        page.should_not have_selector '#phone_book_entry_full_name.error'
      end
    end
  end
end
