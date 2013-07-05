class PhoneBookEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :full_name, :phone_number, :errors, :valid?
end

