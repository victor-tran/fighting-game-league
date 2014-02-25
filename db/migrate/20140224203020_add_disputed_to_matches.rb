class AddDisputedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :disputed, :boolean
  end
end
