require 'spec_helper'

describe "Authentication" do

  subject { page }

  # Test Sign in page (Sessions new page)
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger') }

      # Testing to see if the flash error disappears when visiting another page
      # other than the sign in page.
      describe "after visiting another page" do
        before { click_link "About" }
        it { should_not have_selector('div.alert.alert-danger') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
      end

      describe "but is not a registered user" do
        before do
          user.confirmed = false
          user.save
          click_button "Sign in"
        end

        it { should have_selector('div.alert.alert-danger') }
      end

      describe "and is a registered user" do
        before { click_button "Sign in" }

        # Check navbar links that should change after signing in.
        it { should have_link('Fighters',    href: users_path) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
        it { should have_link('Sign out',    href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }

        # Check to see that Sign in link replaces sign out link after signing out.
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end

  # Testing access to user's edit page when signed/not signed in.
  describe "authorization" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    describe "for non-signed-in users" do

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Leagues controller" do
        
        let(:league) { FactoryGirl.create(:league) }

        describe "visiting the new page" do
          before { visit new_league_path }
          it { should have_title('Sign in') }
          it { should have_selector('div.alert.alert-success') }
        end

        describe "visiting the edit page" do
          before { visit edit_league_path(league) }
          it { should have_title('Sign in') }
          it { should have_selector('div.alert.alert-success') }
        end

        describe "submitting to the update action" do
          before { patch league_path(league) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Users controller" do

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
          end

          describe "as a non-registered user" do
            before do
              user.confirmed = false
              user.save
              click_button "Sign in"
            end

            it { should have_selector('div.alert.alert-danger') }
          end

          describe "as a registered user" do
            before { click_button "Sign in" }

            describe "after signing in" do
              it "should render the desired protected page" do
                expect(page).to have_title('Edit user')
              end
            end
          end
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end

end