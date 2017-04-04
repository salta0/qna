class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :name, :string
    add_column :users, :location, :string
    add_column :users, :description, :text
  end
end
