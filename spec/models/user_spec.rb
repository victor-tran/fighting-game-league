require 'spec_helper'

describe User do
  before do
    @user = User.new(
              first_name: "Victor",
              last_name: "Tran",
              alias: "BurlyChalice",
              email: "dfaced@gmail.com",
              password: "foobar",
              password_confirmation: "foobar",
              fight_bucks: "50",
              uuid: SecureRandom.uuid,
              confirmed: false)
  end

  subject { @user }

  # User attribute checks.
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:alias) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:fight_bucks) }
  it { should respond_to(:avatar) }
  it { should respond_to(:memberships) }
  it { should respond_to(:leagues) }
  it { should respond_to(:p1_matches) }
  it { should respond_to(:p2_matches) }
  it { should respond_to(:matches) }
  it { should respond_to(:bets) }
  it { should respond_to(:uuid) }
  it { should respond_to(:confirmed) }
  it { should respond_to(:playoffs_started) }

  # User method checks.
  it { should respond_to(:authenticate) }
  it { should respond_to(:full_name) }
  it { should respond_to(:member_of?) }
  it { should respond_to(:join!) }
  it { should respond_to(:leave!) }
  it { should respond_to(:betting_on?) }
  it { should respond_to(:bet!) }
  it { should respond_to(:fighting_in?) }
  it { should respond_to(:current_matches) }
  it { should respond_to(:current_streak) }
  it { should respond_to(:longest_win_streak_ever) }
  it { should respond_to(:pending_matches) }
  it { should respond_to(:league_disputes) }

  # Check to see that subject user is valid.
  it { should be_valid }

  describe "when first_name is not present" do
    before { @user.first_name = " " }
    it { should_not be_valid }
  end

  describe "when last_name is not present" do
    before { @user.last_name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when alias is not present" do
    before { @user.alias = " " }
    it { should_not be_valid }
  end

  describe "when first_name is too long" do
    before { @user.first_name = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when last_name is too long" do
    before { @user.last_name = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(
              first_name: "Victor",
              last_name: "Tran",
              alias: "BurlyChalice",
              email: "dfaced@gmail.com",
              password: " ",
              password_confirmation: " ",
              fight_bucks: "50",
              uuid: SecureRandom.uuid,
              confirmed: false)
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "joining leagues" do
    let(:league) { FactoryGirl.create(:league) }
    before do
      @user.save
      @user.join!(league)
    end

    it { should be_member_of(league) }
    its(:leagues) { should include(league) }

    describe "and leaving leagues" do
      before { @user.leave!(league) }

      it { should_not be_member_of(league) }
      its(:leagues) { should_not include(league) }
    end
  end

  describe "full_name" do
    it "is equal to a user's first name + 'alias' + last name" do
      test_name = @user.first_name + " '" + @user.alias + "' " + @user.last_name
      test_name.should eq(@user.full_name)
    end
  end

  describe "current_matches" do
    before do
      @user.save

      # Create 3 leagues and have subject join each one.
      3.times { FactoryGirl.create(:league, current_round: 1, current_season_number: 1) }
      League.all.each do |league|
        @user.join!(league)
      end
      
      # Create 3 more users and have them join the 3 leagues.
      3.times do
        new_user = FactoryGirl.create(:user)
        
        League.all.each do |league|
          new_user.join!(league)
        end
      end

      # Generate matches for each of the leagues.
      League.all.each do |league|
        league.generate_matches
      end
    end

    it "should return the matches in the first round for all leagues" do 
      current_matches = @user.current_matches
      expect(@user.matches.count).to eq(9)
      expect(current_matches.count).to eq(3)

      # Make sure that each match returned from current_matches is only for the
      # first round of each league.
      current_matches.each do |match|
        expect(match.round_number).to eq(1)
      end
    end
  end

  describe "current_streak" do
    before do
      @user.save

      # Create 3 leagues and have subject join each one.
      3.times { FactoryGirl.create(:league, current_round: 1, current_season_number: 1) }
      League.all.each do |league|
        @user.join!(league)
      end
      
      # Create 3 more users and have them join the 3 leagues.
      3.times do
        new_user = FactoryGirl.create(:user)
        
        League.all.each do |league|
          new_user.join!(league)
        end
      end

      # Generate matches for each of the leagues.
      League.all.each do |league|
        league.generate_matches
      end

      @league_1 = @user.leagues.first
      @league_2 = @user.leagues[1]
      @league_3 = @user.leagues.last
    end

    describe "when user has no decided matches" do
      it "should return 0" do
        expect(@user.current_streak(@user.matches)).to eq(0)
      end

      describe "for user's total match history" do
        it "should return 0" do
          expect(@user.current_streak(@user.matches)).to eq(0)
        end
      end

      describe "for only one league" do 
        it "should return 0" do
          expect(@user.current_streak(@league_1.matches.where(
                    "season_number = ? AND (p1_id = ? OR p2_id = ?)",
                     @league_1.current_season_number, @user.id, @user.id))).to eq(0)
        end
      end
    end

    describe "when user has decided matches" do
      before do
        # Match Results: L1: L, L2: W, L3: L, L2: W
        @user.current_matches.each do |match|
          if match.league == @league_1
            if match.p1 == @user
              match.p1_score = 0
              match.p2_score = 5
            else
              match.p1_score = 5
              match.p2_score = 0
            end
            match.finalized_date = DateTime.new(2013, 9, 1, 22, 35, 0)
            match.save!
          elsif match.league == @league_2
            if match.p1 == @user
              match.p1_score = 5
              match.p2_score = 4
            else
              match.p1_score = 4
              match.p2_score = 5
            end
            match.finalized_date = DateTime.new(2013, 9, 2, 22, 35, 0)
            match.save!
          elsif match.league == @league_3
            if match.p1 == @user
              match.p1_score = 3
              match.p2_score = 5
            else
              match.p1_score = 5
              match.p2_score = 3
            end
            match.finalized_date = DateTime.new(2013, 9, 3, 22, 35, 0)
            match.save!
          end
        end

        @league_2.current_round = 2
        @user.current_matches.each do |match|
          if match.league == @league_2
            if match.p1 == @user
              match.p1_score = 5
              match.p2_score = 4
            else
              match.p1_score = 4
              match.p2_score = 5
            end
            match.finalized_date = DateTime.new(2013, 9, 4, 22, 35, 0)
            match.save!
          end
        end
      end

      describe "for user's total match history" do
        it "should return W1" do
          expect(@user.current_streak(@user.matches)).to eq("W1")
        end
      end

      describe "for only one league" do 
        it "should return W2" do
          expect(@user.current_streak(@league_2.matches.where(
                    "season_number = ? AND (p1_id = ? OR p2_id = ?)",
                     @league_2.current_season_number, @user.id, @user.id))).to eq("W2")
        end
      end
    end 
  end

  describe "longest_win_streak_ever" do
    before do
      @user.save

      # Create 3 leagues and have subject join each one.
      3.times { FactoryGirl.create(:league, current_round: 1, current_season_number: 1) }
      League.all.each do |league|
        @user.join!(league)
      end
      
      # Create 3 more users and have them join the 3 leagues.
      3.times do
        new_user = FactoryGirl.create(:user)
        
        League.all.each do |league|
          new_user.join!(league)
        end
      end

      # Generate matches for each of the leagues.
      League.all.each do |league|
        league.generate_matches
      end

      @league_1 = @user.leagues.first
      @league_2 = @user.leagues[1]
      @league_3 = @user.leagues.last
    end

    describe "when user has no decided matches" do
      it "should return 0" do
        expect(@user.longest_win_streak_ever).to eq(0)
      end
    end

    describe "when user has decided matches" do
      before do
        # Match Results: L1: L, L2: W, L3: L, L2: W
        @user.current_matches.each do |match|
          if match.league == @league_1
            if match.p1 == @user
              match.p1_score = 0
              match.p2_score = 5
            else
              match.p1_score = 5
              match.p2_score = 0
            end
            match.finalized_date = DateTime.new(2013, 9, 1, 22, 35, 0)
            match.save!
          elsif match.league == @league_2
            if match.p1 == @user
              match.p1_score = 5
              match.p2_score = 4
            else
              match.p1_score = 4
              match.p2_score = 5
            end
            match.finalized_date = DateTime.new(2013, 9, 2, 22, 35, 0)
            match.save!
          elsif match.league == @league_3
            if match.p1 == @user
              match.p1_score = 3
              match.p2_score = 5
            else
              match.p1_score = 5
              match.p2_score = 3
            end
            match.finalized_date = DateTime.new(2013, 9, 3, 22, 35, 0)
            match.save!
          end
        end

        @league_2.current_round = 2
        @user.current_matches.each do |match|
          if match.league == @league_2
            if match.p1 == @user
              match.p1_score = 5
              match.p2_score = 4
            else
              match.p1_score = 4
              match.p2_score = 5
            end
            match.finalized_date = DateTime.new(2013, 9, 4, 22, 35, 0)
            match.save!
          end
        end
      end

      it "should return 1" do
        expect(@user.longest_win_streak_ever).to eq(1)
      end
    end
  end

  describe "pending_matches" do
    before do
      @user.save

      # Create 3 leagues and have subject join each one.
      3.times { FactoryGirl.create(:league, current_round: 1, current_season_number: 1) }
      League.all.each do |league|
        @user.join!(league)
      end
      
      # Create 3 more users and have them join the 3 leagues.
      3.times do
        new_user = FactoryGirl.create(:user)
        
        League.all.each do |league|
          new_user.join!(league)
        end
      end

      # Generate matches for each of the leagues.
      League.all.each do |league|
        league.generate_matches
      end

      @league_1 = @user.leagues.first
      @league_2 = @user.leagues[1]
      @league_3 = @user.leagues.last
    end

    describe "with no characters, date, or score set" do
      it "should return all current matches" do
        expect(@user.pending_matches).to_not be_empty
        expect(@user.pending_matches.count).to eq(3)
      end
    end

    # Setting either/both p1/p2 characters should still consider the match as
    # pending.
    describe "setting" do
      before { @match = @user.pending_matches.first }

      describe "p1 characters, date, and accepting as p1 in a match where user is p1" do
        before do
          @match.p1_characters = ["22"]
          @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
          @match.p1_accepted = true
        end

        it "should return one less pending match" do
          expect(@user.pending_matches).to_not be_empty
          expect(@user.pending_matches.count).to eq(2)
        end
      end

      # Setting player 1's character first.
      describe "player 1's character," do
        before do
          @match.p1_characters = ["22"]
        end

        it "should return all current matches" do
          expect(@user.pending_matches).to_not be_empty
          expect(@user.pending_matches.count).to eq(3)
        end

        describe "then the match date," do
          before do
            @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "and finally p1_accepted in a match where user is p1" do
            before do
              @match.p1_accepted = true
            end

            it "should return one less pending match" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(2)
            end
          end

          describe "then player 2's character," do
            before do
              @match.p2_characters = ["22"]
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "and finally p1_accepted in a match where user is p1" do
              before do
                @match.p1_accepted = true
              end

              it "should return one less pending match" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(2)
              end
            end

            describe "then p2_accepted in a match where user is p1," do
              before do
                @match.p2_accepted = true
              end

              it "should return all current matches" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(3)
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end
            end
          end
        end

        describe "then player 2's character," do
          before do
            @match.p2_characters = ["22"]
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "then the match date," do
            before do
              @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "and finally p1_accepted in a match where user is p1" do
              before do
                @match.p1_accepted = true
              end

              it "should return one less pending match" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(2)
              end
            end

            describe "then p2_accepted in a match where user is p1," do
              before do
                @match.p2_accepted = true
              end

              it "should return all current matches" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(3)
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end
            end
          end
        end
      end

      # Setting player 2's character first.
      describe "player 2's character," do
        before do
          @match.p2_characters = ["23"]
        end

        it "should return all current matches" do
          expect(@user.pending_matches).to_not be_empty
          expect(@user.pending_matches.count).to eq(3)
        end

        describe "then the match date," do
          before do
            @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "then player 1's character," do
            before do
              @match.p1_characters = ["22"]
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "and finally p1_accepted in a match where user is p1" do
              before do
                @match.p1_accepted = true
              end

              it "should return one less pending match" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(2)
              end
            end

            describe "then p2_accepted in a match where user is p1," do
              before do
                @match.p2_accepted = true
              end

              it "should return all current matches" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(3)
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end
            end
          end
        end

        describe "then player 1's character," do
          before do
            @match.p1_characters = ["22"]
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "then the match date," do
            before do
              @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "and finally p1_accepted in a match where user is p1" do
              before do
                @match.p1_accepted = true
              end

              it "should return one less pending match" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(2)
              end
            end

            describe "then p2_accepted in a match where user is p1," do
              before do
                @match.p2_accepted = true
              end

              it "should return all current matches" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(3)
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end
            end
          end
        end
      end

      # Setting match date character first.
      describe "match date" do
        before do
          @match.match_date = DateTime.new(2013, 9, 3, 22, 35, 0)
        end

        it "should return all current matches" do
          expect(@user.pending_matches).to_not be_empty
          expect(@user.pending_matches.count).to eq(3)
        end

        describe "then player 1's character," do
          before do
            @match.p1_characters = ["22"]
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "and finally p1_accepted in a match where user is p1" do
            before do
              @match.p1_accepted = true
            end

            it "should return one less pending match" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(2)
            end
          end

          describe "then player 2's character," do
            before do
              @match.p2_characters = ["23"]
            end

            describe "then p2_accepted in a match where user is p1," do
              before do
                @match.p2_accepted = true
              end

              it "should return all current matches" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(3)
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end
            end
          end
        end


        describe "then player 2's character," do
          before do
            @match.p2_characters = ["22"]
          end

          it "should return all current matches" do
            expect(@user.pending_matches).to_not be_empty
            expect(@user.pending_matches.count).to eq(3)
          end

          describe "then p2_accepted in a match where user is p1," do
            before do
              @match.p2_accepted = true
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "then player 1's character," do
              before do
                @match.p1_characters = ["23"]
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end 
            end
          end

          describe "then player 1's character," do
            before do
              @match.p1_characters = ["23"]
            end

            describe "and finally p1_accepted in a match where user is p1" do
              before do
                @match.p1_accepted = true
              end

              it "should return one less pending match" do
                expect(@user.pending_matches).to_not be_empty
                expect(@user.pending_matches.count).to eq(2)
              end
            end 
          end

          describe "then p2_accepted in a match where user is p1," do
            before do
              @match.p2_accepted = true
            end

            it "should return all current matches" do
              expect(@user.pending_matches).to_not be_empty
              expect(@user.pending_matches.count).to eq(3)
            end

            describe "then player 1's character," do
              before do
                @match.p1_characters = ["23"]
              end

              describe "and finally p1_accepted in a match where user is p1" do
                before do
                  @match.p1_accepted = true
                end

                it "should return one less pending match" do
                  expect(@user.pending_matches).to_not be_empty
                  expect(@user.pending_matches.count).to eq(2)
                end
              end 
            end
          end
        end
      end
    end
  end

  describe "league_disputes" do
    before do
      @user.save

      # Create 3 leagues and have subject join each one.
      3.times { FactoryGirl.create(:league, current_round: 1, current_season_number: 1) }
      League.all.each do |league|
        @user.join!(league)
      end
      
      # Create 3 more users and have them join the 3 leagues.
      3.times do
        new_user = FactoryGirl.create(:user)
        
        League.all.each do |league|
          new_user.join!(league)
        end
      end

      # Generate matches for each of the leagues.
      League.all.each do |league|
        league.generate_matches
      end

      @league_1 = @user.leagues.first
      @league_2 = @user.leagues[1]
      @league_3 = @user.leagues.last

      # Mock disputed matches.
      @disputed_match = @league_1.matches.first
      @disputed_match.disputed = true
      @disputed_match.save
    end

    describe "with no commissioned leagues" do
      it "should return no disputed matches" do
        expect(@user.league_disputes).to be_empty
      end
    end

    describe "with one commissioned league" do

      before do
        @league_1.commissioner_id = @user.id
        @league_1.save
      end

      it "should return disputed matches" do
        expect(@user.league_disputes).to_not be_empty
        expect(@user.league_disputes.count).to eq(1)
      end
    end
  end

  describe "betting on matches" do
    let(:fav_user) { FactoryGirl.create(:user) }
    let(:match) { FactoryGirl.create(:match) }
    before do
      @user.save
      @user.bet!(match, fav_user, 50)
    end

    it { should be_betting_on(match) }
    its(:bets) { should include(Bet.where("match_id = ? AND 
                                           favorite_id = ? AND 
                                           wager_amount = ?", 
                                           match.id, 
                                           fav_user.id, 
                                           50).first) }

  end

  describe "fighting_in?" do
    let(:match) { FactoryGirl.create(:match) }

    describe "when user is not fighting in match" do
      it "should return false" do
        expect(@user.fighting_in?(match)).to eq(false)
      end
    end

    describe "when user is fighting in match as player 1" do
      before do
        match.p1_id = @user.id
      end
      it "should return true" do
        expect(@user.fighting_in?(match)).to eq(true)
      end
    end

    describe "when user is fighting in match as player 2" do
      before do
        match.p2_id = @user.id
      end
      it "should return true" do
        expect(@user.fighting_in?(match)).to eq(true)
      end
    end
  end
end
