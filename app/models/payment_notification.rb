class PaymentNotification < ActiveRecord::Base
  belongs_to :user
  serialize :params
  after_create :give_user_fight_bucks

  private
    def give_user_fight_bucks
      if status == "Completed"
        user.update_attribute(:fight_bucks, user.fight_bucks + item_number)
      end
    end
end
