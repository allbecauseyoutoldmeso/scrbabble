class Tile  < ActiveRecord::Base
  belongs_to :tileable, polymorphic: true
  belongs_to :word, optional: :true
  belongs_to :turn, optional: :true

  def latest?
    turn&.latest?
  end

  def inactivate_multipotent
    update(multipotent: false) if multipotent?
  end
end
