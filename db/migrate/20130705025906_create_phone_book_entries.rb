class CreatePhoneBookEntries < ActiveRecord::Migration
  def change
    create_table :phone_book_entries do |t|
      t.string :full_name
      t.string :phone_number

      t.timestamps
    end
  end
end
