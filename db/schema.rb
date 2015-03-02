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

ActiveRecord::Schema.define(version: 20150215182128) do

  create_table "containers", force: :cascade do |t|
    t.integer  "ingredient_id"
    t.float    "volume_init"
    t.float    "volume_actual"
    t.float    "price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "containers", ["ingredient_id"], name: "index_containers_on_ingredient_id"

  create_table "ingredient_types", force: :cascade do |t|
    t.string   "name"
    t.string   "name_short"
    t.string   "mesure_unit"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
  end

  add_index "ingredients", ["ingredient_type_id"], name: "index_ingredients_on_ingredient_type_id"

  create_table "ingredients_recipes", id: false, force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "recipe_id",     null: false
  end

  add_index "ingredients_recipes", ["ingredient_id", "recipe_id"], name: "index_ingredients_recipes_on_ingredient_id_and_recipe_id", unique: true

  create_table "products", force: :cascade do |t|
    t.integer  "variant_id"
    t.string   "name"
    t.float    "volume"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "products", ["variant_id"], name: "index_products_on_variant_id"

  create_table "proportions", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "composant_id"
    t.string   "composant_type"
    t.float    "value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "proportions", ["composant_type", "composant_id"], name: "index_proportions_on_composant_type_and_composant_id"
  add_index "proportions", ["variant_id"], name: "index_proportions_on_variant_id"

  create_table "recipe_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.integer  "recipe_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "recipes", ["recipe_type_id"], name: "index_recipes_on_recipe_type_id"

  create_table "variants", force: :cascade do |t|
    t.string   "name"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "variants", ["recipe_id"], name: "index_variants_on_recipe_id"

end
