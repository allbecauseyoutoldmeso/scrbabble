class Premium < ActiveRecord::Base
  self.table_name = 'premiums'
  belongs_to :square
  enum target: [:word, :letter]

  def inactivate
    update(active: false)
  end
end
