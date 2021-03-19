module ApplicationHelper
  def premium_label(premium)
    if premium
      t("games.show.premium.#{premium.target}.#{premium.tuple}")
    end
  end

  def user_player(game, user)
    Player.find_by(game: game, user: user)
  end

  def other_player(game, user)
    Player.where(game: game).where.not(user: user).first
  end

  def can_swap_tiles?(tile_bag)
    tile_bag.tiles.length >= TileRack::MAXIMUM_TILES
  end
end
