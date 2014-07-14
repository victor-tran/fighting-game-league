require 'spec_helper'

describe League do
  before do
    @league = League.new(
              name: "Example League",
              game_id: 1,
              commissioner_id: 1,
              started: false,
              current_round: 0,
              info: "Example info",
              match_count: 5,
              playoffs_started: false,
              time_zone: 'Eastern Time (US & Canada)')
  end

  subject { @league }

  # League attribute checks.
  it { should respond_to(:name) }
  it { should respond_to(:game_id) }
  it { should respond_to(:commissioner_id) }
  it { should respond_to(:started) }
  it { should respond_to(:current_round) }
  it { should respond_to(:info) }
  it { should respond_to(:match_count) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:banner) }
  it { should respond_to(:playoffs_started) }
  it { should respond_to(:memberships) }
  it { should respond_to(:users) }
  it { should respond_to(:matches) }
  it { should respond_to(:game) }
  it { should respond_to(:tournaments) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:posts) }
  it { should respond_to(:time_zone) }
  it { should respond_to(:current_season) }

  # League method checks.
  it { should respond_to(:authenticate) }
  it { should respond_to(:total_rounds) }
  it { should respond_to(:has_more_rounds_left_in_season?) }
  it { should respond_to(:total_matches_played) }
  it { should respond_to(:generate_matches) }
  it { should respond_to(:start_playoffs) }
  it { should respond_to(:playoffs_complete?) }
  it { should respond_to(:playoffs_underway?) }
  it { should respond_to(:awaiting_review?) }
  it { should respond_to(:end_playoffs) }
  it { should respond_to(:fighters) }

  # Check to see that subject league is valid.
  it { should be_valid }

  describe "when name is not present" do
    before { @league.name = " " }
    it { should_not be_valid }
  end

  describe "when game_id is not present" do
    before { @league.game_id = " " }
    it { should_not be_valid }
  end

  describe "when commissioner_id is not present" do
    before { @league.commissioner_id = " " }
    it { should_not be_valid }
  end

  describe "when started is not present" do
    before { @league.started = nil }
    it { should_not be_valid }
  end

  describe "when time_zone is not present" do
    before { @league.time_zone = nil }
    it { should_not be_valid }
  end

  describe "when current_round is not present" do
    before { @league.current_round = " " }
    it { should_not be_valid }
  end

  describe "when info is not present" do
    before { @league.info = " " }
    it { should_not be_valid }
  end

  describe "when match_count is not present" do
    before { @league.match_count = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @league.name = "a" * 41 }
    it { should_not be_valid }
  end

  describe "when league name is already taken" do
    before do
      league_with_same_name = @league.dup
      league_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "with 4 users" do
    before do
      @league = FactoryGirl.create(:league)
      4.times do
        user = FactoryGirl.create(:user)
        user.join!(@league)
      end
      @league.seasons.create!(number: 1,
                              current_season: true,
                              fighters: @league.fighters)
    end

    describe "total_rounds" do

      it "should return total rounds for a 4 person league" do
        expect(@league.total_rounds).to eq(3)
      end
    end

    describe "has_more_rounds_left_in_season" do

      # Since the test league is a 4 person league, 
      # the total rounds for the season is 3.
      describe "with more rounds left in season" do
        it "should return true" do
          expect(@league.has_more_rounds_left_in_season?).to eq(true)
        end
      end

      describe "with no more rounds left in season" do
        before { @league.current_round = 3 }
        it "should return false" do
          expect(@league.has_more_rounds_left_in_season?).to eq(false)
        end
      end
    end

    describe "matches_for_current_season" do

      describe "with no matches generated" do
        it "should return an empty match array" do
          expect(@league.current_season.matches).to be_empty
        end
      end

      describe "with matches generated" do
        before do
          @league.current_round = 1
          @league.generate_matches
        end

        describe "for one season" do
          before { @matches = @league.current_season.matches }

          it "should return an array of matches for the first season" do
            expect(@matches).to_not be_empty
            expect(@matches.count).to eq(6)

            # Check that each match is only for the first season.
            @matches.each do |match|
              expect(match.season.number).to eq(1)
            end
          end
        end

        describe "for multiple seasons" do
          before do
            @league.current_season.update_attribute(:current_season, false)
            @league.seasons.create!(number: 2,
                                    current_season: true,
                                    fighters: @league.fighters)
            @league.generate_matches
            @matches = @league.current_season.matches
          end

          it "should return an array of matches for the second season" do
            expect(@matches).to_not be_empty
            expect(@matches.count).to eq(6)

            # Check that each match is only for the second season.
            @matches.each do |match|
              expect(match.season.number).to eq(2)
            end
          end
        end
      end
    end

    describe "total_matches_played" do

      describe "with no matches generated" do
        it "should return 0" do
          expect(@league.total_matches_played).to eq(0)
        end
      end

      describe "with matches generated" do
        before do
          @league.current_round = 1
          @league.generate_matches
        end

        describe "with no matches played" do
          it "should return 0" do
            expect(@league.total_matches_played).to eq(0)
          end
        end

        describe "with matches played" do
          before do
            3.times do |i|
              @league.matches[i].finalized_date = Date.today
            end
          end

          it "should return 3" do
            expect(@league.total_matches_played).to eq(3)
          end
        end
      end
    end

    describe "generate_matches" do
      before do
        @league.generate_matches
        @matches = @league.current_season.matches
      end

      it "should generate matches that are associated with the league" do
        expect(@matches).to_not be_empty
        expect(@matches.count).to eq(6)
      end

      it "should make sure that each player only plays once per round" do
        matches_per_round = @league.users.count / 2

        # The hashmap that will keep track of who has already been
        # scheduled to play for that round.
        user_hashmap = {}

        # The flag that will determine if the algorithm worked correctly.
        flag = true

        # For each round in the league, check to see that each player only
        # fights once.
        for i in 1..@league.total_rounds

          # Will reset all user's scheduled values to false before each round.
          @league.users.each do |user|
            user_hashmap[user] = false
          end

          matches_for_current_round = @league.matches.where("round_number = ?", i)
          
          # For each match check to see if each user has been scheduled, if not
          # set their values to true, otherwise fail the test.
          matches_for_current_round.each do |match|
            if user_hashmap[match.p1] == true || user_hashmap[match.p2] == true
              flag = false
              break
            else
              user_hashmap[match.p1] = true
              user_hashmap[match.p2] = true
            end
          end

          # No reason to keep looping if the algorithm has already failed.
          if flag == false
            break
          end
        end

        # Obviously expect the algorithm to work!
        expect(flag).to be(true)
      end
    end
  end

  describe "start_playoffs" do
    it "is a pending example"
  end

  describe "end_playoffs" do
    it "is a pending example"
  end

  describe "playoffs_complete?" do
    it "is a pending example"
  end

  describe "playoffs_underway?" do
    it "is a pending example"
  end

  describe "awaiting_review?" do
    it "is a pending example"
  end

  describe "followers" do
    before do
      @league.save
      @user = FactoryGirl.create(:user)
      @user.follow_league!(@league)
    end
    its(:followers) { should include(@user) }
  end

  describe "post associations" do
    it "is a pending example"
  end
end
