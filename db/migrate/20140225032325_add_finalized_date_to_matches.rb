class AddFinalizedDateToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :finalized_date, :datetime
  end
end
