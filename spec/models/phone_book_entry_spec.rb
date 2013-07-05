require 'spec_helper'

describe PhoneBookEntry do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:phone_number) }

  context "::import_csv" do
    let!(:entry_1) { FactoryGirl.create :phone_book_entry, full_name: 'Victor', phone_number: '12345678' }
    let!(:entry_2) { FactoryGirl.create :phone_book_entry, full_name: 'Basil',  phone_number: '23456789' }

    let(:csv) do
      <<-CSV
Full name;Phone number
Victor;987654321
Alex;876543210
CSV
    end

    before do
      PhoneBookEntry.import_csv csv
    end

    specify { PhoneBookEntry.count.should be == 3 }
    specify { entry_1.reload.phone_number.should be == '987654321' }
    specify { PhoneBookEntry.find_by_full_name('Alex').phone_number.should be == '876543210' }
  end

  context "::to_csv" do
    let!(:entry_1) { FactoryGirl.create :phone_book_entry, full_name: 'Victor', phone_number: '12345678' }
    let!(:entry_2) { FactoryGirl.create :phone_book_entry, full_name: 'Basil',  phone_number: '23456789' }

    it "returns correct CSV data" do
      PhoneBookEntry.to_csv.should be == <<-CSV
Full name;Phone number
Victor;12345678
Basil;23456789
CSV
    end
  end
end
