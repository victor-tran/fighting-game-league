module MatchesHelper

  # Returns bet info for match.
  def match_bet_info(match)
    player_bet_info = {}
    p1_bet_count = Bet.where("match_id = ? AND favorite_id = ?", match.id, match.p1_id).count
    p2_bet_count = Bet.where("match_id = ? AND favorite_id = ?", match.id, match.p2_id).count

    if p1_bet_count == 0 && p2_bet_count == 0
      p1_percent = 0
      p2_percent = 0
    else 
      p1_percent  = (p1_bet_count.to_f / (p1_bet_count + p2_bet_count)) * 100
      p2_percent = (p2_bet_count.to_f / (p1_bet_count + p2_bet_count)) * 100
    end

    player_bet_info[:p1_bet_count] = p1_bet_count
    player_bet_info[:p2_bet_count] = p2_bet_count
    player_bet_info[:p1_percent] = p1_percent
    player_bet_info[:p2_percent] = p2_percent
    player_bet_info[:p1_fight_bucks] = match.bets.sum(:wager_amount, conditions: {favorite_id: [match.p1_id]})
    player_bet_info[:p2_fight_bucks] = match.bets.sum(:wager_amount, conditions: {favorite_id: [match.p2_id]})

    player_bet_info
  end

  def embed(youtube_url)
    youtube_id = youtube_url.split("=").last
    content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
  end
end
