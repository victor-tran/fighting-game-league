class ChangeP1AndP2CharactersToStringArrays < ActiveRecord::Migration
  def change
    change_column :matches, :p1_characters, :string, array: true
    change_column :matches, :p2_characters, :string, array: true
  end
end
