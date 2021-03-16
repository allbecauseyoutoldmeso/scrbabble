class Game < ActiveRecord::Base
  has_one :tile_bag
  has_one :board
  has_many :players
  belongs_to :current_player, class_name: 'Player', optional: true
  after_create :create_board
  after_create :create_tile_bag
  after_create :assign_initial_tiles
  after_create :set_current_player

  attr_accessor :announcement
  attr_accessor :error_message

  BONUS = 50

  # this is a monster - refactor
  def play_turn(data)
    begin
      word_smith = WordSmith.new(data: data, board: board)
      word_smith.assign_tiles
      current_player.add_points(word_smith.points)

      self.announcement = I18n.t(
        'games.announcements.points_update',
        player: current_player.name,
        points: word_smith.points
      )

      word_smith.inactivate_premiums
      word_smith.inactivate_multipotents
      assign_new_tiles(current_player)
      toggle_current_player
    rescue WordSmith::InvalidWord
      self.error_message = I18n.t('games.error_messages.invalid_word')
    end
  end

  def skip_turn
    self.announcement = I18n.t(
      'games.announcements.skipped_turn',
      player: current_player.name,
    )

    toggle_current_player
  end

  def player_1
    players.first
  end

  def player_2
    players.last
  end

  private

  def set_current_player
    update(current_player: player_1)
  end

  def assign_initial_tiles
    players.each { |player| assign_new_tiles(player) }
  end

  def assign_new_tiles(player)
    player.spaces.times do
      tile_bag.reload.random_tile&.update(tileable: player.tile_rack)
    end
  end

  def toggle_current_player
    update(current_player: next_player)
  end

  def next_player
    current_player == player_1 ? player_2 : player_1
  end

  def create_tile_bag
    TileBag.create(game: self)
  end

  def create_players
    2.times do
      Player.create(game: self)
    end
  end

  def create_board
    Board.create(game: self)
  end
end
