class Game < ActiveRecord::Base
  has_one :tile_bag
  has_one :board
  has_many :players
  belongs_to :current_player, class_name: 'Player', optional: true
  after_create :create_board
  after_create :create_tile_bag
  after_create :create_players
  after_create :assign_initial_tiles
  after_create :set_current_player


  def play_turn(data)
    word_smith = WordSmith.new(data: data, board: board)
    if word_smith.valid?
      word_smith.save
      # current_player.add_points(word_smith.points)
      # assign_tiles(current_player)
      # toggle_current_player
    end
  end

  def set_current_player
    update(current_player: player_1)
  end

  def assign_initial_tiles
    players.each { |player| assign_tiles(player) }
  end

  def assign_tiles(player)
    player.spaces.times do
      tile_bag.reload.random_tile.update(tileable: player.tile_rack)
    end
  end

  def player_1
    players.first
  end

  def player_2
    players.last
  end

  private

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
