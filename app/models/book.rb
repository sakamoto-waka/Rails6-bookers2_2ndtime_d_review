class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  # これでBook.tagsが取得できる？
  has_many :tags, through: :book_tags

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :rate, numericality: { less_than_or_equal_to: 5,
                                   greater_than_or_equal_to: 1 }

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :high_rate, -> { order(rate: :desc) }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)

    if search == 'perfect_match'
      Book.where(title: word)
    elsif search == 'forward_match'
      Book.where('title LIKE ? OR body LIKE ?', "#{word}%", "#{word}%")
    elsif search == 'backward_match'
      Book.where('title LIKE ? OR body LIKE ?', "%#{word}", "%#{word}")
    else
      Book.where('title LIKE ? OR body LIKE ?', "%#{word}%", "%#{word}%")
    end
  end

  def save_tag(sent_tags)
    # カラムの中身を一つの配列（集合体？）にして取得してくれる、（一つ一つ ,　で区切って）
    # 今持ってるtagsをひとまとめにしてる↓
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    # 古い（重複してる）タグは消す
    old_tags.each do |old_tag|
      self.tags.delete Tag.find_by(name: old_tag)
    end

    # 新しい（重複していない）タグはtagsの中に代入する
    new_tags.each do |new_tag|
      new_book_tag = Tag.find_or_create_by(name: new_tag)
      # 代入！
      self.tags << new_book_tag
      # book_tags.new(user_id: user_id, tag_id: new_book_tag.id).save
    end
  end

end