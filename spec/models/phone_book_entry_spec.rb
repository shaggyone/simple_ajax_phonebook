require 'spec_helper'

describe PhoneBookEntry do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:phone_number) }
end
