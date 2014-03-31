class UserMailer < ActionMailer::Base
  default from: "do-not-reply@fighting-game-league.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  

  # Email after signing up as a new user
  def signup_confirmation(user)
    @user = user
    mail to: @user.email, subject: "Sign Up Confirmation",
                          content_type: "text/html"
  end
end
