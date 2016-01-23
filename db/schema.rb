# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160123082953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "container_references", force: :cascade do |t|
    t.integer  "ingredient_type_id"
    t.integer  "volume"
    t.integer  "mass"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "container_references", ["ingredient_type_id"], name: "index_container_references_on_ingredient_type_id", using: :btree

  create_table "containers", force: :cascade do |t|
    t.integer  "ingredient_id"
    t.integer  "quantity_init"
    t.integer  "quantity_actual"
    t.integer  "price"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
  end

  add_index "containers", ["ingredient_id"], name: "index_containers_on_ingredient_id", using: :btree
  add_index "containers", ["user_id"], name: "index_containers_on_user_id", using: :btree

  create_table "ingredient_types", force: :cascade do |t|
    t.string   "name"
    t.string   "name_short"
    t.string   "mesure_unit"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "density"
  end

  create_table "ingredient_types_recipe_types", id: false, force: :cascade do |t|
    t.integer "ingredient_type_id", null: false
    t.integer "recipe_type_id",     null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.integer  "ingredient_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "density"
  end

  add_index "ingredients", ["ingredient_type_id"], name: "index_ingredients_on_ingredient_type_id", using: :btree

  create_table "ingredients_recipes", id: false, force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "recipe_id",     null: false
  end

  add_index "ingredients_recipes", ["ingredient_id", "recipe_id"], name: "index_ingredients_recipes_on_ingredient_id_and_recipe_id", unique: true, using: :btree

  create_table "ingredients_variants", id: false, force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "variant_id",    null: false
  end

  add_index "ingredients_variants", ["ingredient_id", "variant_id"], name: "index_ingredients_variants_on_ingredient_id_and_variant_id", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "variant_id"
    t.string   "container"
    t.integer  "volume"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "number_produced"
    t.datetime "production_date"
    t.datetime "expiration_date"
    t.integer  "user_id"
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree
  add_index "products", ["variant_id"], name: "index_products_on_variant_id", using: :btree

  create_table "proportions", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "composant_id"
    t.string   "composant_type"
    t.integer  "value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "proportions", ["composant_type", "composant_id"], name: "index_proportions_on_composant_type_and_composant_id", using: :btree
  add_index "proportions", ["variant_id"], name: "index_proportions_on_variant_id", using: :btree

  create_table "recipe_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "density"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.integer  "recipe_type_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.boolean  "shared",          default: false, null: false
    t.integer  "variant_base_id"
  end

  add_index "recipes", ["recipe_type_id"], name: "index_recipes_on_recipe_type_id", using: :btree
  add_index "recipes", ["shared"], name: "index_recipes_on_shared", using: :btree
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "rank"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",               default: false, null: false
    t.integer  "role_id"
    t.string   "name"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "variants", force: :cascade do |t|
    t.string   "name"
    t.integer  "recipe_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "description"
    t.boolean  "archived"
    t.integer  "next_version_id"
  end

  add_index "variants", ["recipe_id"], name: "index_variants_on_recipe_id", using: :btree
  add_index "variants", ["user_id"], name: "index_variants_on_user_id", using: :btree

  add_foreign_key "container_references", "ingredient_types"
  add_foreign_key "containers", "ingredients"
  add_foreign_key "containers", "users"
  add_foreign_key "ingredients", "ingredient_types"
  add_foreign_key "products", "users"
  add_foreign_key "products", "variants"
  add_foreign_key "proportions", "variants"
  add_foreign_key "recipes", "recipe_types"
  add_foreign_key "recipes", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "variants", "recipes"
  add_foreign_key "variants", "users"
end
