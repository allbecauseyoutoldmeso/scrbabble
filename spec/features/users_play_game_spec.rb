require 'rails_helper'

describe 'users play game', js: true do
  let(:user_1) { create(:user, name: 'user_1', password: 'password') }
  let(:user_2) { create(:user, name: 'user_2', password: 'password') }
  let(:player_1) { create(:player, user: user_1) }
  let(:player_2) { create(:player, user: user_2) }
  let!(:game) { create(:game, players: [player_1, player_2]) }
  let(:player_1_tiles) { player_1.tiles }
  let(:player_2_tiles) { player_2.tiles }
  let(:turn_1_tiles) { player_1.tiles.first(3) }
  let(:turn_2_tiles) { player_2.tiles.first(3) }
  let(:board) { game.board }

  before do
    allow_any_instance_of(DictionaryClient)
      .to receive(:valid_scrabble_word?)
      .and_return(true)
  end

  scenario 'user plays turn' do
    log_in(user_1)
    visit(game_path(game))

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_1.name)
    )

    place_tile(
      turn_1_tiles[0],
      board.square(Board::BOARD_SIZE/2 + 0, Board::BOARD_SIZE/2)
    )
    place_tile(
      turn_1_tiles[1],
      board.square(Board::BOARD_SIZE/2 + 1, Board::BOARD_SIZE/2)
    )
    place_tile(
      turn_1_tiles[2],
      board.square(Board::BOARD_SIZE/2 + 2, Board::BOARD_SIZE/2)
    )
    click_button(I18n.t('games.show.submit_word'))

    within("#player_#{player_1.id}_score") do
      expect(page).to have_content(turn_1_tiles.map(&:points).sum * 2)
    end

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_2.name)
    )

    expect(game.latest_turn.seen).to eq(false)

    click_button('log out')
    log_in(user_2)
    visit(game_path(game))

    expect(game.latest_turn.seen).to eq(true)

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_2.name)
    )

    place_tile(
      turn_2_tiles[0],
      board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 1)
    )
    place_tile(
      turn_2_tiles[1],
      board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 2)
    )
    place_tile(
      turn_2_tiles[2],
      board.square(Board::BOARD_SIZE/2, Board::BOARD_SIZE/2 + 3)
    )
    click_button(I18n.t('games.show.submit_word'))

    expected_score = turn_2_tiles.map(&:points).sum + turn_1_tiles[0].points

    within("#player_#{player_2.id}_score") do
      expect(page).to have_content(expected_score)
    end

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_1.name)
    )
  end

  scenario 'user skips turn' do
    log_in(user_1)
    visit(game_path(game))

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_1.name)
    )

    click_button(I18n.t('games.show.skip_turn'))

    within('.modal') do
      find("#swappable_tile_#{turn_1_tiles[0].id}").click
      click_button(I18n.t('games.show.continue'))
    end

    expect(page).to have_content(
      I18n.t('games.announcements.skipped_turn', player: player_1.name)
    )

    expect(page).to have_content(
      I18n.t('games.show.players_turn', player: player_2.name)
    )

    expect(all("#tile_#{turn_1_tiles[0].id}").empty?).to eq(true)
  end

  scenario 'user shuffles tiles', js: true do
    log_in(user_1)
    visit(game_path(game))
    letter_elements = all('.tile-letter')

    original_letters = letter_elements.map do |letter|
      letter['innerHTML'].split("\n")[1].strip
    end

    click_button(I18n.t('games.show.shuffle'))
    letter_elements = all('.tile-letter')

    shuffled_letters = letter_elements.map do |letter|
      letter['innerHTML'].split("\n")[1].strip
    end

    expect(shuffled_letters).not_to eq(original_letters)
    expect(shuffled_letters).to contain_exactly(*original_letters)
  end

  scenario 'game over' do
    game.tile_bag.tiles.each(&:destroy)

    player_1
      .tile_rack
      .tiles
      .last(TileRack::MAXIMUM_TILES - 3)
      .each(&:destroy)

    log_in(user_1)
    visit(game_path(game))

    place_tile(
      turn_1_tiles[0],
      board.square(Board::BOARD_SIZE/2 + 0, Board::BOARD_SIZE/2)
    )

    place_tile(
      turn_1_tiles[1],
      board.square(Board::BOARD_SIZE/2 + 1, Board::BOARD_SIZE/2)
    )

    place_tile(
      turn_1_tiles[2],
      board.square(Board::BOARD_SIZE/2 + 2, Board::BOARD_SIZE/2)
    )

    click_button(I18n.t('games.show.submit_word'))
    expect(page).to have_content(I18n.t('games.announcements.game_over'))
  end

  def place_tile(tile, square)
    tile_element = find("#tile_#{tile.id}")
    square_element = find("#square_#{square.id}")
    tile_element.drag_to(square_element)
  end
end
