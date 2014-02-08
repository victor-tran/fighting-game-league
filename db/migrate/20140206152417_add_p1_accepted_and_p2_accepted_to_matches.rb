class AddP1AcceptedAndP2AcceptedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :p1_accepted, :boolean
    add_column :matches, :p2_accepted, :boolean
  end
end
