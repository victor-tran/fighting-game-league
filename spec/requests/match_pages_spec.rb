require 'spec_helper'

describe "Matches pages" do
  let(:game) { FactoryGirl.create(:game) }
  let(:player_1) { FactoryGirl.create(:user) }
  let(:player_2) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league, game_id: game.id,
                                             commissioner_id: player_1.id,
                                             started: true,
                                             current_round: 1,
                                             current_season_number: 1) }

  subject { page }

  before do
    game.characters.create!(name: "Ryu")
    game.characters.create!(name: "Ken")
    game.characters.create!(name: "E. Honda")
    game.characters.create!(name: "Ibuki")
    game.characters.create!(name: "Makoto")
    game.characters.create!(name: "Dudley")
    game.characters.create!(name: "Seth")
    game.characters.create!(name: "Gouken")
    game.characters.create!(name: "Akuma")
    game.characters.create!(name: "Gen")
    game.characters.create!(name: "Dan")
    game.characters.create!(name: "Sakura")
    game.characters.create!(name: "Oni")
    game.characters.create!(name: "Yun")
    game.characters.create!(name: "Juri")
    game.characters.create!(name: "Chun Li")
    game.characters.create!(name: "Dhalsim")
    game.characters.create!(name: "Abel")
    game.characters.create!(name: "C. Viper")
    game.characters.create!(name: "Dictator")
    game.characters.create!(name: "Sagat")
    game.characters.create!(name: "Cammy")
    game.characters.create!(name: "Deejay")
    game.characters.create!(name: "Cody")
    game.characters.create!(name: "Guy")
    game.characters.create!(name: "Hakan")
    game.characters.create!(name: "Yang")
    game.characters.create!(name: "Evil Ryu")
    game.characters.create!(name: "Guile")
    game.characters.create!(name: "Blanka")
    game.characters.create!(name: "Zangief")
    game.characters.create!(name: "Rufus")
    game.characters.create!(name: "El Fuerte")
    game.characters.create!(name: "Claw")
    game.characters.create!(name: "Boxer")
    game.characters.create!(name: "Fei Long")
    game.characters.create!(name: "T. Hawk")
    game.characters.create!(name: "Adon")
    game.characters.create!(name: "Rose")
    game.characters.create!(name: "Poison")
    game.characters.create!(name: "Hugo")
    game.characters.create!(name: "Rolento")
    game.characters.create!(name: "Elena")
    game.characters.create!(name: "Decapre")
    player_1.join!(league)
    player_2.join!(league)
    league.generate_matches
    @match = league.matches.first
    sign_in player_1
  end

  after(:all) do
    User.delete_all
    League.delete_all
    Match.delete_all
    Character.delete_all
  end

  describe "index" do
    before { visit matches_path }
    
    it { should have_title("Matches") }
    it { should_not have_content("Commissioner Disputes") }
    it { should have_content("League Matches") }

    # Test setting player 1's characters for a match.
    describe "setting player 1's characters" do
      before do
        @match.game_id = game.id
        @match.p1_id = player_1.id
        @match.p2_id = player_2.id
        click_link "Set P1 Character"
      end

      it { should have_title("Select P1 Character") }
      it { should have_content("Select P1 Character") }

      describe "with no characters selected" do
        before do
          click_button "Select Character"
        end

        # Testing no flash notice after not selecting any characters.
        it { should_not have_selector('div.alert.alert-success',
                                   text: 'P1 character set.') }
      end

      describe "with one character selected" do
        before do
          check("Ken")
          click_button "Select Character"
        end

        # Testing flash notice after successful character selection.
        it { should have_selector('div.alert.alert-success',
                                   text: 'P1 character set.') }
      end

      describe "with multiple characters selected" do
        before do
          check "Decapre"
          check "Ken"
          check "E. Honda"
          click_button "Select Character"
        end

        # Testing flash notice after successful character selection.
        it { should have_selector('div.alert.alert-success',
                                   text: 'P1 character set.') }
      end
    end

    # Test edit date match page.
    describe "match date" do
      describe "as player 1" do
        before { click_link "Set Date" }

        it { should have_title("Set Date") }
        it { should have_content("Set Date") }

        # set date and time
      end
    end

    # Test setting scores for a match.
    describe "setting match scores" do
      it "is a pending example"

      # Test that both p1 and p2 characters and the date are set, before
      # you're able to set the score.
    end

    # Test resolving a dispute.
    describe "resolving a dispute" do
      it "is a pending example"
    end
  end

  describe "show" do
    it "is a pending example"
  end
end