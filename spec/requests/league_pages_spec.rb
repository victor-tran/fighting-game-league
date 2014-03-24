require 'spec_helper'

describe "League pages" do

  subject { page }

  # Test new league page.
  describe "new league" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Create League" }
    before(:all) do
      Game.create!(name: "Ultra Street Fighter IV",
               logo: "usf4_logo.jpg")
      Game.create!(name: "Ultimate Marvel vs. Capcom 3",
                   logo: "umvc3_logo.png")
      Game.create!(name: "Injustice: Gods Among Us",
                   logo: "injustice_logo.png")
      Game.create!(name: "Super Smash Bros. Melee",
                   logo: "melee_logo.png")
      Game.create!(name: "Killer Instinct",
                   logo: "ki_logo.png")
      Game.create!(name: "King of Fighters XIII",
                   logo: "kof_13_logo.jpg")
      Game.create!(name: "Street Fighter x Tekken",
                   logo: "sfxt_logo.jpg")
      Game.create!(name: "Persona 4 Arena",
                   logo: "p4a_logo.png")
      Game.create!(name: "Tekken Tag Tournament 2",
                   logo: "ttt2_logo.jpg")
      Game.create!(name: "Mortal Kombat 9",
                   logo: "mk_logo.png")
      Game.create!(name: "Skullgirls",
                   logo: "skullgirls_logo.png")
      Game.create!(name: "Divekick",
                   logo: "divekick_logo.png")
      Game.create!(name: "Dead or Alive 5 Ultimate",
                   logo: "doa5u_logo.png")
      Game.create!(name: "Virtua Fighter 5 Final Showdown",
                   logo: "vf5fs_logo.png")
      Game.create!(name: "Street Fighter III: 3rd Strike",
                   logo: "sf3_3s_logo.png")
    end
    after(:all) do
      Game.delete_all
    end
    before do
      sign_in user
      visit new_league_path
    end

    it { should have_title("New League") }

    # Filling out no fields.
    describe "with no fields filled in" do
      it "should not create a league" do
        expect { click_button submit }.not_to change(League, :count)
      end

      describe "after submission" do
        before { click_button submit }

        # Test title after signing up with invalid information.
        it { should have_title("New League") }

        # Test error messages.
        it { should have_content("error") }
      end
    end

    # Filling out all fields with valid information.
    describe "with valid information" do
      before do
        fill_in "Name",            with: "El Classico"
        select "Killer Instinct",  from: "Game"
        select "10",               from: "Number of Games for Win"
        fill_in "Info",            with: "blah blah blah"
      end

      describe "for a non-password protected league" do
        
        it "should create a league" do
          expect { click_button submit }.to change(League, :count).by(1)
        end

        describe "after saving the league" do
          before { click_button submit }

          # El Classico should have been created in the DB.
          let(:league) { League.find_by(name: 'El Classico') }

          # Test title.
          it { should have_title("El Classico") }
          it { should have_content("El Classico") }
          it { should have_content("Game: Killer Instinct") }
          it { should have_content("Match Count: First-to-10") }
          it { should have_content("About: blah blah blah") }

          # Testing flash notice after successful signin.
          it { should have_selector('div.alert.alert-success',
                              text: 'League created!') }
        end
      end

      describe "for a password protected league" do
        it "is a pending example"
      end
    end
  end

  # Test league index page.
  describe "index" do
    before { visit leagues_path }

    # Assert that title and h1 content are present.
    it { should have_title("All leagues") }
    it { should have_content("All leagues") }

    # Assert that search query field and button are present.
    it { find_field('query') }
    it { find('#league_search').should have_button('Search') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:league) } }
      after(:all)  { League.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each league" do
        # There are only 20 leagues per page, so there should be 2 pages.
        League.paginate(page: 2).each do |league|
          expect(page).to have_selector('li', text: league.name)
        end
      end
    end

    describe "searching" do

      # Create 35 leagues, 30 named 'Example League X' and 5 named 'Test League X'
      before(:all) do
        30.times { FactoryGirl.create(:league) }
        5.times { |n| FactoryGirl.create(:league, name: "Test League " + n.to_s) }
      end
      after(:all)  { League.delete_all }

      # Test searching for a single word.
      describe "for 'test'" do
        before do
          fill_in "query", with: "test"
          click_button "Search"
        end

        it { should have_title("All leagues") }
        it { should have_content("All leagues") }
        it { should_not have_selector('div.pagination') }

        it "should list 5 test leagues" do
          search_results = League.text_search("test")

          # Assert that only 5 leagues come back.
          search_results.count.should eq(5)

          search_results.each do |league|
            league.name.should include("Test League")
            league.name.should_not include("Example League")
          end
        end
      end

      # Test stemming of search words i.e. searching 'tests' will search 'test'
      # as well as 'tests'.
      describe "for 'tests'" do
        before do
          fill_in "query", with: "tests"
          click_button "Search"
        end

        it { should have_title("All leagues") }
        it { should have_content("All leagues") }
        it { should_not have_selector('div.pagination') }

        it "should list 5 test leagues" do
          search_results = League.text_search("tests")

          # Assert that only 5 leagues come back.
          search_results.count.should eq(5)

          search_results.each do |league|
            league.name.should include("Test League")
            league.name.should_not include("Example League")
          end
        end
      end

      # Test omission of stop words. i.e. 'the, of, etc...'
      describe "for 'the test'" do
        before do
          fill_in "query", with: "the test"
          click_button "Search"
        end

        it { should have_title("All leagues") }
        it { should have_content("All leagues") }
        it { should_not have_selector('div.pagination') }

        it "should list 5 test leagues" do
          search_results = League.text_search("the test")

          # Assert that only 5 leagues come back.
          search_results.count.should eq(5)

          search_results.each do |league|
            league.name.should include("Test League")
            league.name.should_not include("Example League")
          end
        end
      end

      # Test a blank search
      describe "with a blank query" do
        before do
          fill_in "query", with: " "
          click_button "Search"
        end

        it { should have_title("All leagues") }
        it { should have_content("All leagues") }
        it { should have_selector('div.pagination') }

        it "should list all leagues" do
          search_results = League.text_search(" ")

          # Assert that all 35 leagues come back.
          search_results.count.should eq(35)

          League.paginate(page: 1).each do |league|
            league.name.should_not include("Test League")
            league.name.should include("Example League")
          end

          League.paginate(page: 2).each do |league|
            league.name.should include("Test League")
            league.name.should_not include("Example League")
          end
        end
      end

      # Test a search that doesn't match any leagues.
      describe "for leagues that do not exist" do
        before do
          fill_in "query", with: "snapple"
          click_button "Search"
        end

        it { should have_title("All leagues") }
        it { should have_content("All leagues") }
        it { should_not have_selector('div.pagination') }

        it "should not list any leagues" do
          search_results = League.text_search("snapple")

          # Assert that 0 leagues come back.
          search_results.count.should eq(0)

          search_results.each do |league|
            league.name.should_not include("Test League")
            league.name.should_not include("Example League")
          end
        end
      end
    end
  end

  # Test league show page.
  describe "show" do

    # Test everything that should be on a league's show page regardless of
    # being a signed in user or not.
    describe "page" do

      let(:user) { FactoryGirl.create(:user) }
      let(:league) { FactoryGirl.create(:league, commissioner_id: user.id) }
      before do
        visit league_path(league)
      end
      
      it { should have_title(league.name) }
      it { should have_link('Profile') }
      it { should have_link('Standings') }
      it { should have_link('Statistics') }
      it { should have_link('Fighters') }
    end

    # Test signed in-user landing on show page.
    describe "user signed in" do
      it "is a pending example"

      describe "as a commissioner" do
        it "is a pending example"
      end

      describe "as a normal league member" do
        it "is a pending example"
      end
    end
  end

end