require "spec_helper"

describe UserMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "signup_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.signup_confirmation(user) }

    before { mail.deliver }

    it "renders the headers" do
      mail.subject.should eq("Sign Up Confirmation")
      mail.to.should eq([user.email])
      mail.from.should eq(["do-not-reply@fighting-game-league.com"])
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should eq(1)
    end

    it "renders user's alias" do
      mail.body.encoded.should match(user.alias)
    end

    it "renders link to user's profile page" do
      mail.body.encoded.should match("http://localhost:3000/users/#{user.id}")
    end

    describe "renders confirmation link" do
      it "is a pending example"
      #mail.body.encoded.should match("http://localhost:3000/users/#{user.id}/confirmation")
    end
  end
end
