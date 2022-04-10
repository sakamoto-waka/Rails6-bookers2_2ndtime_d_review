class AddUserIdToBookTag < ActiveRecord::Migration[6.1]
  def change
    add_reference :book_tags, :user, foreign_key: true
  end
end
