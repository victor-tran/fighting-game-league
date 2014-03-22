require 'spec_helper'

describe "League pages" do

  subject { page }

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
      it "is a pending example"
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