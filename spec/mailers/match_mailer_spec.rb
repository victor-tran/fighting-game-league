require "spec_helper"

describe MatchMailer do

  let(:player_1) { FactoryGirl.create(:user, alias: "Player 1") }
  let(:player_2) { FactoryGirl.create(:user, alias: "Player 2") }
  let(:league) { FactoryGirl.create(:league, name: "FGL Invite") }
  let(:test_match) { FactoryGirl.create(:match, p1_id: player_1.id,
                                           p2_id: player_2.id,
                                           league_id: league.id) }
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "p1_set_score" do
    let(:mail) { MatchMailer.p1_set_score(test_match) }

    before do
      test_match.p1_score = 5
      test_match.p2_score = 3
      test_match.p1_accepted
      mail.deliver
    end

    it "renders the headers" do
      mail.subject.should eq("FGL Invite: Score set 5-3 in match vs. Player 1")
      mail.to.should eq([player_2.email])
      mail.from.should eq(["do-not-reply@fighting-game-league.com"])
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should eq(1)
    end

    it "renders match score" do
      mail.body.encoded.should match("Player 1 set the score of the match to 5-3")
    end

    it "renders link to user's matches index page" do
      mail.body.encoded.should match("http://localhost:3000/matches")
    end

    describe "renders accept/decline/dispute buttons" do
      it "is a pending example"
    end
  end

  describe "p2_set_score" do
    let(:mail) { MatchMailer.p2_set_score(test_match) }

    before do
      test_match.p1_score = 5
      test_match.p2_score = 3
      test_match.p2_accepted
      mail.deliver
    end

    it "renders the headers" do
      mail.subject.should eq("FGL Invite: Score set 5-3 in match vs. Player 2")
      mail.to.should eq([player_1.email])
      mail.from.should eq(["do-not-reply@fighting-game-league.com"])
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should eq(1)
    end

    it "renders match score" do
      mail.body.encoded.should match("Player 2 set the score of the match to 5-3")
    end

    it "renders link to user's matches index page" do
      mail.body.encoded.should match("http://localhost:3000/matches")
    end

    describe "renders accept/decline/dispute buttons" do
      it "is a pending example"
    end
  end
end
