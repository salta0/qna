class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.integer :votable_id, index: true
      t.string :votable_type, index: true
      t.integer :user_id, index: true    
      t.timestamps null: false
    end
  end
end