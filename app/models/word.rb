class Word < ActiveRecord::Base
  belongs_to :player
  has_many :tiles

  def points
    tiles.map(&:points).sum
  end
end
