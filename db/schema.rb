# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170911171241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "citext"

  create_table "assignments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "group_id"
    t.uuid "permission_id"
  end

  create_table "feedbacks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "cid",                           null: false
    t.string   "name",                          null: false
    t.string   "email",                         null: false
    t.string   "callsign",                      null: false
    t.string   "controller"
    t.string   "position"
    t.integer  "service_level",                 null: false
    t.text     "comments",                      null: false
    t.boolean  "fly_again",     default: true
    t.boolean  "published",     default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "groups", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string  "name",                              null: false
    t.boolean "artcc_controllers", default: false
  end

  create_table "permissions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "positions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                                                   null: false
    t.decimal  "frequency",      precision: 6, scale: 3,                 null: false
    t.string   "callsign",                                               null: false
    t.string   "identification",                                         null: false
    t.string   "beacon_codes"
    t.boolean  "major",                                  default: false, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "cid",                             null: false
    t.string   "name_first",                      null: false
    t.string   "name_last",                       null: false
    t.string   "email",              default: "", null: false
    t.string   "rating",                          null: false
    t.datetime "reg_date",                        null: false
    t.uuid     "group_id",                        null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "initials"
    t.index ["cid"], name: "index_users_on_cid", unique: true, using: :btree
  end

end
