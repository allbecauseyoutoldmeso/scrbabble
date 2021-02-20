require 'rails_helper'

describe 'user plays game', js: true do
  let(:user_1) { create(:user, name: 'user_1', password: 'password') }
  let(:user_2) { create(:user, name: 'user_2', password: 'password') }
  let(:player_1) { create(:player, user: user_1) }
  let(:player_2) { create(:player, user: user_2) }
  let!(:game) { create(:game, players: [player_1, player_2]) }
  let(:player_1_tiles) { player_1.tiles }
  let(:player_2_tiles) { player_2.tiles }
  let(:board) { game.board }
  let(:turn_1_tiles) { player_1_tiles.first(3) }

  scenario 'user plays word' do
    log_in(user_1)
    visit(game_path(game))
    expect(page).to have_content("#{player_1.name}'s turn")
    place_tile(player_1_tiles[0], board.square(0, 0))
    place_tile(player_1_tiles[1], board.square(1, 0))
    place_tile(player_1_tiles[2], board.square(2, 0))
    click_button('submit word')

    expect(page).to have_content(
      "#{player_1.name}: #{turn_1_tiles.map(&:points).sum * 3}"
    )
    expect(page).to have_content("#{player_2.name}'s turn")
  end

  def place_tile(tile, square)
    tile_element = find("#tile_#{tile.id}")
    square_element = find("#square_#{square.id}")
    tile_element.drag_to(square_element)
  end
end
