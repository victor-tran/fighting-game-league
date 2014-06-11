class AddVideosToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :videos, :string, array: true, default: []
  end
end
