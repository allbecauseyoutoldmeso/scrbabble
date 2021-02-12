# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_09_143746) do

  create_table "boards", force: :cascade do |t|
    t.integer "game_id"
    t.index ["game_id"], name: "index_boards_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "current_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "game_id"
    t.integer "points"
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "squares", force: :cascade do |t|
    t.integer "x"
    t.integer "y"
    t.integer "board_id"
    t.index ["board_id"], name: "index_squares_on_board_id"
  end

  create_table "tile_bags", force: :cascade do |t|
    t.integer "game_id"
    t.index ["game_id"], name: "index_tile_bags_on_game_id"
  end

  create_table "tile_racks", force: :cascade do |t|
    t.integer "player_id"
    t.index ["player_id"], name: "index_tile_racks_on_player_id"
  end

  create_table "tiles", force: :cascade do |t|
    t.string "letter"
    t.integer "points"
    t.bigint "tileable_id"
    t.string "tileable_type"
    t.integer "word_id"
  end

  create_table "words", force: :cascade do |t|
    t.integer "player_id"
    t.index ["player_id"], name: "index_words_on_player_id"
  end

end
