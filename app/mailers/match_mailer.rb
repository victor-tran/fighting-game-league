class MatchMailer < ActionMailer::Base
  default from: "do-not-reply@fighting-game-league.com"

  # Email player 2 after player 1 set the score
  def p1_set_score(match)
    @match = match
    mail to: @match.p2.email,
         subject: @match.league.name + ": Score set " +
                  @match.p1_score.to_s + "-" + @match.p2_score.to_s +
                  " in match vs. " + @match.p1.alias,
         content_type: "text/html"
  end

  # Email player 1 after player 2 set the score
  def p2_set_score(match)
    @match = match
    mail to: @match.p1.email,
         subject: @match.league.name + ": Score set " +
                  @match.p1_score.to_s + "-" + @match.p2_score.to_s +
                  " in match vs. " + @match.p2.alias,
         content_type: "text/html"
  end
end
