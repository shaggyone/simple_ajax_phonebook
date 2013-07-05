class PhoneBookEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :full_name, :phone_number
end

