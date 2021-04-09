class Game < ActiveRecord::Base
  has_one :tile_bag
  has_one :board
  has_many :players
  has_many :tile_racks, through: :players
  belongs_to :current_player, class_name: 'Player', optional: true
  has_many :turns

  after_create :create_board
  after_create :create_tile_bag
  after_create :assign_initial_tiles
  after_create :set_current_player

  attr_accessor :error_message

  BONUS = 50

  def self.current
    where(finished: false)
  end

  def self.finished
    where(finished: true)
  end

  # turned into a monster again - refactor
  def play_turn(data)
    word_smith = WordSmith.new(data: data, board: board)
    word_smith.process_data
    create_turn(word_smith.points, word_smith.tiles)
    end_game if over?
    assign_new_tiles(current_player)
    toggle_current_player
  rescue WordSmith::InvalidWord
    self.error_message = I18n.t("games.error_messages.invalid_word")
  end

  def skip_turn(tile_ids = [])
    swap_tiles(tile_ids) if tile_ids.any?
    create_turn(0)
    end_game if over?
    toggle_current_player
  end

  def player_1
    players.first
  end

  def player_2
    players.last
  end

  def latest_turn
    turns.order(:created_at).last
  end

  private

  def end_game
    subtract_remaining_tiles
    update(finished: true)
  end

  def over?
    tile_bag.empty? &&
      (tile_racks.any?(&:empty?) || turns.last(2).all?(&:skipped?))
  end

  def subtract_remaining_tiles
    players.each do |player|
      tiles = player.tiles
      if tiles.any?
        points = - tiles.map(&:points).sum
        create_turn(points, tiles, player)
      end
    end
  end

  def create_turn(points, tiles = [], player = current_player)
    Turn.create(
      game: self,
      player: player,
      points: points,
      tiles: tiles
    )
  end

  def swap_tiles(tile_ids)
    tile_ids.each do |id|
      tile = Tile.find(id)
      tile.update(tileable: tile_bag)
      tile_bag.reload.random_tile.update(tileable: current_player.tile_rack)
    end
  end

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
