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

  pending "Find a way to test it" do
  scenario 'User should be able to download phone book as csv file' do
    click_link 'download'

    page.text.should be == <<-CSV
Full name;Phone number
A;3124344
B;4213423
C;5342523
D;6236343
CSV
  end
  end

  context 'adding an entry' do
    scenario 'User adds an entry' do
      within '#PhoneBook' do
        within '.Form' do
          fill_in 'phone_book_entry_full_name',    with: 'Victor'
          fill_in 'phone_book_entry_phone_number', with: '5346-4234'

          click_button 'Save entry'
        end

        page.should have_content 'Full name Phone number
                                  A 3124344
                                  B 4213423
                                  C 5342523
                                  D 6236343
                                  Victor 5346-4234'
      end
    end

    scenario 'User forgets to add name' do
      within '#PhoneBook .Form' do
        fill_in 'phone_book_entry_full_name',    with: ''
        fill_in 'phone_book_entry_phone_number', with: '5346-4234'

        click_button 'Save entry'

        page.should have_selector '#phone_book_entry_full_name.error'
        page.should_not have_selector '#phone_book_entry_phone_number.error'
      end
    end

    scenario 'User forgets to add phone_number' do
      within '#PhoneBook .Form' do
        fill_in 'phone_book_entry_full_name',    with: 'Victor'
        fill_in 'phone_book_entry_phone_number', with: ''

        click_button 'Save entry'

        page.should have_selector '#phone_book_entry_phone_number.error'
        page.should_not have_selector '#phone_book_entry_full_name.error'
      end
    end
  end

  context 'editin an entry' do
    background do
      all('#PhoneBook .Index tr').first.find('.Edit').click
    end

    scenario "User sees form displays data" do
      within '#PhoneBook .Form' do
        page.find('#phone_book_entry_full_name').value.should be == 'A'
        page.find('#phone_book_entry_phone_number').value.should be == '3124344'
      end
    end

    scenario 'Used updates data in table' do
      within '#PhoneBook' do
        within '.Form' do
          fill_in 'phone_book_entry_full_name',    with: 'Victor'
          fill_in 'phone_book_entry_phone_number', with: '5346-4234'

          click_button 'Save entry'
        end

        page.should have_content 'Full name Phone number
                                  Victor 5346-4234
                                  B 4213423
                                  C 5342523
                                  D 6236343'
      end
    end

    scenario 'User forgets to add name' do
      within '#PhoneBook' do
        within '.Form' do
          fill_in 'phone_book_entry_full_name',    with: ''
          fill_in 'phone_book_entry_phone_number', with: '5346-4234'

          click_button 'Save entry'

          page.should have_selector '#phone_book_entry_full_name.error'
          page.should_not have_selector '#phone_book_entry_phone_number.error'
        end

        page.should have_content 'Full name Phone number
                                  A 3124344
                                  B 4213423
                                  C 5342523
                                  D 6236343'
      end
    end

    scenario 'User forgets to add phone_number' do
      within '#PhoneBook' do
        within '.Form' do
          fill_in 'phone_book_entry_full_name',    with: 'Victor'
          fill_in 'phone_book_entry_phone_number', with: ''

          click_button 'Save entry'

          page.should have_selector '#phone_book_entry_phone_number.error'
          page.should_not have_selector '#phone_book_entry_full_name.error'
        end

        page.should have_content 'Full name Phone number
                                  A 3124344
                                  B 4213423
                                  C 5342523
                                  D 6236343'
      end
    end
  end

  context 'removing an entry' do
    scenario "Removes corresponding entry if user confirms it" do
      page.evaluate_script('window.confirm = function() { return true; }')
      all('#PhoneBook .Index tr').first.find('.Destroy').click

      page.should have_content 'Full name Phone number
                                B 4213423
                                C 5342523
                                D 6236343'
    end

    scenario "Does not remove corresponding entry if user confirms it" do
      page.evaluate_script('window.confirm = function() { return false; }')
      all('#PhoneBook .Index tr').first.find('.Destroy').click

      page.should have_content 'Full name Phone number
                                A 3124344
                                B 4213423
                                C 5342523
                                D 6236343'
    end
  end
end
