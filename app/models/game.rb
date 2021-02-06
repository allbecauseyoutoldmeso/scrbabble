class Game < ActiveRecord::Base
  has_one :tile_bag
  has_one :board
  has_many :players
  after_create :create_tile_bag
  after_create :create_players
  after_create :create_board


  def assign_tiles(player)
    new_tiles = tile_bag.random_tiles(player.spaces)
    player.tiles.push(*new_tiles)
  end

  def play_tile(x, y, tile)
    tile.update(tileable: board.square(x, y))
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
