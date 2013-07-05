# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_book_entry do
    full_name    { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
