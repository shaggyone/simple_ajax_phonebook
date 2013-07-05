class PhoneBookEntry < ActiveRecord::Base
  attr_accessible :full_name, :phone_number
  validates_presence_of :full_name, :phone_number
end
