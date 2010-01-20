require 'rubygems'
require "active_record"
require "action_view"
require "rateable_attributes"
require File.dirname(__FILE__)+"/../generators/templates/migration.rb"

ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:"
})

ActiveRecord::Schema.define(:version => 1) do
  RateableAttributesMigration.up
  
  create_table :projects, :force=>true do |t|
    t.string :name
    t.timestamps
  end
end

class Project < ActiveRecord::Base
  rateable_attributes :usability, :performance, :functionality
  validates_presence_of :name
end