class AddAttachmentBannerToLeagues < ActiveRecord::Migration
  def self.up
    change_table :leagues do |t|
      t.attachment :banner
    end
  end

  def self.down
    drop_attached_file :leagues, :banner
  end
end
