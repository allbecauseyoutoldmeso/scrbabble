class Square < ActiveRecord::Base
  belongs_to :board
  has_one :tile, as: :tileable
  has_one :premium

  def letter_tuple
    letter_premium&.tuple || 1
  end

  def word_tuple
    word_premium&.tuple || 1
  end

  private

  def letter_premium
    premium if premium&.letter?
  end

  def word_premium
    premium if premium&.word?
  end
end
