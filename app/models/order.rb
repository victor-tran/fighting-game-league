class Order < ActiveRecord::Base
  belongs_to :user
  #attr_accessible :amount, :description, :state, :payment_method, :credit_card
  attr_accessor :return_url, :cancel_url, :payment_method
  validates_presence_of :amount, :description, :user_id

  after_create :create_payment

  validate do
    if payment_method == "credit_card" and ( user.credit_card_id.nil? || @credit_card.present? ) and @credit_card.invalid?
      errors.add :create_card, "Validation error"
    end
  end


  def payment
    @payment ||= payment_id && Payment.find(payment_id)
  end

  def credit_card
    user.credit_card
  end

  def credit_card=(hash)
    user.credit_card = hash
  end

  def create_payment
    if payment_method == "credit_card" and !user.save
      raise ActiveRecord::Rollback, "Can't place the order"
    end
    @payment = Payment.new( :order => self )
    if @payment.create
      self.payment_id = @payment.id
      self.state      = @payment.state
      save
    else
      errors.add :payment_method, @payment.error["message"] if @payment.error
      raise ActiveRecord::Rollback, "Can't place the order"
    end
  end

  def execute(payer_id)
    if payment.present? and payment.execute(:payer_id => payer_id)
      self.state = payment.state
      save
    else
      errors.add :description, payment.error.inspect
      false
    end
  end

  def approve_url
    payment.links.find{|link| link.method == "REDIRECT" }.try(:href)
  end

end
