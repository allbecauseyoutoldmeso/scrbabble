class Tile  < ActiveRecord::Base
  belongs_to :tileable, polymorphic: true
end
