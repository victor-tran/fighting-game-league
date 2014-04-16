class Order < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :amount, presence: true
  validates :description, presence: true
  validates :payment_method, presence: true

  after_create :create_payment

  # Attributes
  attr_accessor :return_url, :cancel_url, :payment_method, :credit_card

  def approve_url
    payment.links.find{ |link| link.method == "REDIRECT" }.try(:href)
  end

  def create_payment
    unless payment_method == 'credit_card'
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

  def payment
    @payment ||= payment_id && Payment.find(payment_id)
  end

end
