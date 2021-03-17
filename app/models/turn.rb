class Turn  < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  has_many :tiles

  def latest?
    self == game.latest_turn
  end

  def summary
    if points.zero?
      I18n.t(
        'games.announcements.skipped_turn',
        player: player.name,
      )
    else
      I18n.t(
        'games.announcements.points_update',
        player: player.name,
        points: points
      )
    end
  end
end
