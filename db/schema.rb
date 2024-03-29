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

ActiveRecord::Schema.define(version: 2022_02_13_163128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "canonical_url"
    t.string "author_name"
    t.datetime "published_at"
    t.integer "read_time", default: 0
    t.string "original_image_url"
    t.boolean "metered", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "source_id", null: false
    t.string "image_key"
    t.text "image_placeholder"
    t.integer "bookmarks_count", default: 0, null: false
    t.integer "reactions_count", default: 0, null: false
    t.integer "score", default: 0
    t.decimal "hotness", precision: 10, scale: 6, default: "0.0"
    t.datetime "hotness_updated_at"
    t.integer "views_count", default: 0, null: false
    t.string "author_twitter_uid"
    t.string "author_twitter_username"
    t.index ["source_id"], name: "index_articles_on_source_id"
    t.index ["url", "source_id"], name: "index_articles_on_url_and_source_id", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "article_id"], name: "index_bookmarks_on_user_id_and_article_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.bigint "followable_id", null: false
    t.string "follower_type", null: false
    t.bigint "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower"
  end

  create_table "hidden_articles", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_hidden_articles_on_article_id"
    t.index ["user_id"], name: "index_hidden_articles_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "token"
    t.string "secret"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["provider", "user_id"], name: "index_identities_on_provider_and_user_id", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_request_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.string "secret", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_oauth_request_tokens_on_token"
  end

  create_table "reactions", force: :cascade do |t|
    t.string "reactable_type", null: false
    t.bigint "reactable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable"
    t.index ["user_id", "reactable_id", "reactable_type"], name: "index_reactions_on_user_id_and_reactable_id_and_reactable_type", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.string "category"
    t.text "reason"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "image_key"
    t.string "website_url"
    t.string "feed_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.text "description"
    t.index ["slug"], name: "index_sources_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "profile_image"
    t.string "dismissed_actions", default: [], array: true
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.integer "count", default: 1
    t.bigint "article_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_views_on_article_id"
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  add_foreign_key "articles", "sources"
  add_foreign_key "bookmarks", "articles"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "hidden_articles", "articles"
  add_foreign_key "hidden_articles", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "reactions", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "views", "articles"
  add_foreign_key "views", "users"
end
