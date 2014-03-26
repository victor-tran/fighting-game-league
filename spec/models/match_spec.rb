require 'spec_helper'

describe Match do
  
  let(:league) { FactoryGirl.create(:league) }

  before do
    @match = Match.new(
              round_number: 1, 
              p1_id: 1, 
              p2_id: 2,
              season_number: 1,
              league_id: league.id,
              p1_accepted: false,
              p2_accepted: false,
              game_id: 1,
              p1_score: 0,
              p2_score: 0)
  end

  subject { @match }

  # Match attributes checks.
  it { should respond_to(:round_number) }
  it { should respond_to(:p1_id) }
  it { should respond_to(:p2_id) }
  it { should respond_to(:p1_score) }
  it { should respond_to(:p2_score) }
  it { should respond_to(:season_number) }
  it { should respond_to(:league_id) }
  it { should respond_to(:p1_accepted) }
  it { should respond_to(:p2_accepted) }
  it { should respond_to(:game_id) }
  it { should respond_to(:p1) }
  it { should respond_to(:p2) }
  it { should respond_to(:league) }

  # Match method checks.
  it { should respond_to(:match_scores_are_at_match_count) }
  it { should respond_to(:winner_id) }
  it { should respond_to(:pay_winning_betters) }
  it { should respond_to(:display_score) }
  it { should respond_to(:scores_not_set?) }

  # Check to see that subject match is valid.
  it { should be_valid }

  describe "match_scores_are_at_match_count" do
    
    let(:test_league) { FactoryGirl.create(:league, match_count: 10) }
    before { @match.league_id = test_league.id }

    describe "if p1 score is negative" do
      before { @match.p1_score = -2 }
      it { should_not be_valid }
    end

    describe "if p2 score is negative" do
      before { @match.p2_score = -2 }
      it { should_not be_valid }
    end

    describe "if scores are negative" do
      before do
        @match.p1_score = -2
        @match.p2_score = -2000
      end
      it { should_not be_valid }
    end

    describe "if both scores are 0" do
      it { should be_valid }
    end

    describe "if neither scores are at match count" do
      before do
        @match.p1_score = 9
        @match.p2_score = 2
      end

      it { should_not be_valid }
    end

    describe "if player 1's score is higher than the match count" do
      before do
        @match.p1_score = 11
        @match.p2_score = 10
      end

      it { should_not be_valid }
    end

    describe "if player 2's score is higher than the match count" do
      before do
        @match.p2_score = 11
        @match.p1_score = 10
      end

      it { should_not be_valid }
    end

    describe "if both players scores are higher than the match count" do
      before do
        @match.p1_score = 11
        @match.p2_score = 11
      end

      it { should_not be_valid }
    end

    describe "if both players scores are at the match count" do
      before do
        @match.p1_score = 10
        @match.p2_score = 10
      end

      it { should_not be_valid }
    end

    describe "if one player scores are at the match count" do
      before do
        @match.p1_score = 10
      end

      it { should be_valid }

      describe "and one score is negative" do
        before { @match.p2_score = -1 }
        it { should_not be_valid }
      end
    end
  end

  describe "winner_id" do
    describe "when player 1's score > player 2's score" do

      let(:user) { FactoryGirl.create(:user) }

      before do
        @match.p1_id = user.id
        @match.p1_score = 5
      end

      it "should return player 1's id" do
        expect(@match.winner_id).to eq(user.id)
      end
    end

    describe "when player 2's score > player 1's score" do

      let(:user) { FactoryGirl.create(:user) }

      before do
        @match.p2_id = user.id
        @match.p2_score = 5
      end

      it "should return player 2's id" do
        expect(@match.winner_id).to eq(user.id)
      end
    end
  end

  describe "pay_winning_betters" do

    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }
    let(:player_1) { FactoryGirl.create(:user) }
    let(:player_2) { FactoryGirl.create(:user) }

    before do
      @match.p1_id = player_1.id
      @match.p2_id = player_2.id
      @match.p1_score = 5
      @match.save!
      user_1.bet!(@match, player_1, 50)
      user_2.bet!(@match, player_2, 50)
      @match.pay_winning_betters
    end

    it "should pay player 1 100 fight bucks" do
      winning_id = @match.winner_id
      @match.bets.each do |bet|
        if bet.favorite_id == winning_id
          user = User.find(bet.better_id)
          expect(user.fight_bucks).to eq(100)
        end
      end
    end

    it "should not pay player 2" do
      user_2.fight_bucks.should eq(0)
    end
  end

  describe "display_score" do
    
    let(:user_1) { FactoryGirl.create(:user, alias: "TEST_1") }
    let(:user_2) { FactoryGirl.create(:user, alias: "TEST_2") }

    before do
      @match.p1_id = user_1.id
      @match.p2_id = user_2.id
      @match.p1_score = 100
      @match.p2_score = 200
    end

    it "should display p1 alias + p1_score:p2_score + p2 alias" do
      @match.display_score.should eq("TEST_1 -- 100:200 -- TEST_2")
    end
  end

  describe "scores_not_set?" do

    it "with no scores set" do
      @match.scores_not_set?.should be(true)
    end

    describe "with player 1's score changed" do

      before { @match.p1_score = 2 }

      it "should return false" do
        expect(@match.scores_not_set?).to eq(false)
      end
    end

    describe "with player 2's score changed" do

      before { @match.p2_score = 2 }

      it "should return false" do
        expect(@match.scores_not_set?).to eq(false)
      end
    end

    describe "with both players scores changed" do

      before do 
        @match.p1_score = 2
        @match.p2_score = 5
      end

      it "should return false" do
        expect(@match.scores_not_set?).to eq(false)
      end
    end
  end
end
