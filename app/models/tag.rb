class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy
  has_many :books, through: :book_tags
  
  def self.looks(search, word)
    if search == 'perfect_match'
      Tag.where(name: word)
    elsif search == 'forward_match'
      Tag.where('name LIKE ?', "#{word}%")
    elsif search == 'backward_match'
      Tag.where('name LIKE ?', "%#{word}")
    else
      Tag.where('name LIKE ?', "%#{word}%")
    end
  end
end
