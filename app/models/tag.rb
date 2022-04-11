class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy
  has_many :books, through: :book_tags
  
  def self.looks_books_for(search, word)
    if search == 'perfect_match'
      tags = Tag.where(name: word)
    elsif search == 'forward_match'
      tags = Tag.where('name LIKE ?', "#{word}%")
    elsif search == 'backward_match'
      tags = Tag.where('name LIKE ?', "%#{word}")
    else
      tags = Tag.where('name LIKE ?', "%#{word}%")
    end
    return tags.inject(init = []) { |result, tag| result + tag.books }
    # init = []
    # tags.each do |tag|
    #   return init + tag.books
    # end
  end
end
