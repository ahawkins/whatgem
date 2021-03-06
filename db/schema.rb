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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110307025242) do

  create_table "comments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "ruby_gem_id"
    t.text      "text"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "related_gems", :id => false, :force => true do |t|
    t.integer "parent_id"
    t.integer "child_id"
  end

  create_table "ruby_gems", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "number_of_closed_issues"
    t.integer  "number_of_open_issues"
    t.integer  "number_of_open_pull_requests"
    t.integer  "number_of_closed_pull_requests"
    t.boolean  "has_readme"
    t.boolean  "has_license"
    t.boolean  "has_examples"
    t.float    "rating"
    t.string   "github_url"
    t.string   "documentation_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "test_log"
    t.float    "test_results"
  end

  add_index "ruby_gems", ["name"], :name => "index_ruby_gems_on_name", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer   "tag_id"
    t.integer   "taggable_id"
    t.string    "taggable_type"
    t.integer   "tagger_id"
    t.string    "tagger_type"
    t.string    "context"
    t.timestamp "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",        :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "authentication_token"
    t.string    "gravatar_id"
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

  create_table "votes", :force => true do |t|
    t.integer   "ruby_gem_id"
    t.integer   "user_id"
    t.boolean   "up"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "votes", ["ruby_gem_id"], :name => "index_votes_on_ruby_gem_id"
  add_index "votes", ["up"], :name => "index_votes_on_up"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
