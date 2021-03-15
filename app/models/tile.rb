class Tile  < ActiveRecord::Base
  belongs_to :tileable, polymorphic: true
  belongs_to :word, optional: :true

  def inactivate_multipotent
    update(multipotent: false) if multipotent?
  end
end
