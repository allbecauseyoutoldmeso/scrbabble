class Turn  < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  has_many :tiles

  after_create :enqueue_update

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

  def other_player
    game.players.find { |p| p != player }
  end

  private

  def enqueue_update
    GameUpdateJob.set(wait: 20.minutes).perform_later(id)
  end
end
