module MatchesHelper

  # Returns bet info for match.
  def match_bet_info(match)
    p1_bet_count = Bet.where("match_id = ? AND favorite_id = ?", match.id, match.p1_id).count
    p2_bet_count = Bet.where("match_id = ? AND favorite_id = ?", match.id, match.p2_id).count

    if p1_bet_count == 0 && p2_bet_count == 0
      p1_percent = 0
      p2_percent = 0
    else 
      p1_percent  = (p1_bet_count.to_f / (p1_bet_count + p2_bet_count)) * 100
      p2_percent = (p2_bet_count.to_f / (p1_bet_count + p2_bet_count)) * 100
    end

    # e.g. ( 0 ) 0% | 100% ( 1 )
    "( " + p1_bet_count.to_s + " ) " + 
    number_to_percentage(p1_percent, precision: 0) + 
    " | " + 
    number_to_percentage(p2_percent, precision: 0) + 
    "( " + p2_bet_count.to_s + " )"
  end
end
