require 'csv'

class PhoneBookEntry < ActiveRecord::Base
  attr_accessible :full_name, :phone_number
  validates_presence_of :full_name, :phone_number

  def self.import_csv csv_data
    CSV.parse csv_data, headers: true, col_sep: ';' do |row|
      entry = PhoneBookEntry.where(full_name: row['Full name']).first_or_initialize
      entry.phone_number = row['Phone number']
      entry.save
    end
  end

  def self.to_csv
    CSV.generate col_sep: ';' do |csv|
      csv << ['Full name', 'Phone number']
      PhoneBookEntry.find_each do |entry|
        csv << [entry.full_name, entry.phone_number]
      end
    end
  end
end
