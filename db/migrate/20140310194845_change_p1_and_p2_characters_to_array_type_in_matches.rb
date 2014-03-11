class ChangeP1AndP2CharactersToArrayTypeInMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :p1_character, :integer
    remove_column :matches, :p2_character, :integer

    add_column :matches, :p1_characters, :int, array: true, default: []
    add_column :matches, :p2_characters, :int, array: true, default: []
  end
end
