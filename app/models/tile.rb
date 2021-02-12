class Tile  < ActiveRecord::Base
  belongs_to :tileable, polymorphic: true
  belongs_to :word, optional: :true
end
