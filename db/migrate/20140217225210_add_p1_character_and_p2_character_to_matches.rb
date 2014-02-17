class AddP1CharacterAndP2CharacterToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :p1_character, :integer
    add_column :matches, :p2_character, :integer
  end
end
