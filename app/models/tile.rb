class Tile  < ActiveRecord::Base
  belongs_to :tileable, polymorphic: true
  belongs_to :word, optional: :true

  def inactivate_blank
    update(blank: false) if blank?
  end
end
