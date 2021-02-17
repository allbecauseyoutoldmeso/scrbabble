class Premium < ActiveRecord::Base
  self.table_name = 'premiums'
  belongs_to :square
  enum target: [:word, :letter]
end
