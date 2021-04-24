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

  def new_game?(game, user)
    game.players.find_by(user: user).points.zero?
  end

  def tile_classes(tile)
    [
      'tile',
      'flex-direction-column',
      ('multipotent hintable' if tile.multipotent?),
      ('latest' if tile.latest?)
    ].compact.join(' ')
  end

  def tile_actions(draggable, multipotent)
    [
      (multipotent_actions if multipotent),
      (draggable_actions if draggable)
    ].flatten.compact.join(' ')
  end

  def multipotent_actions
    ['dblclick->tile#onDoubleClick']
  end

  def draggable_actions
    [
      'dragstart->drag#dragStart',
      'dragend->drag#dragEnd',
      'touchstart->touch#touchStart',
      'touchmove->touch#touchMove',
      'touchend->touch#touchEnd',
    ]
  end
end
