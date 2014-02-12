module LeaguesHelper
  def game_options
    [['Street Fighter IV: Arcade Edition 2012', 1], ['Ultimate Marvel vs. Capcom 3', 2]]
  end

  def total_rounds(league)
    matches_per_round = league.users.count / 2
    total_matches = (league.users.count - 1) * matches_per_round
    total_rounds = total_matches / matches_per_round

    total_rounds
  end

  def more_rounds_left_in_season?(league, next_round)
    total_rounds = total_rounds(league)

    next_round > total_rounds
  end

  def matches_for_current_season(league)

    current_matches = Set.new

    league.matches.each do |match|
      if match.season_number == league.current_season_number
        current_matches.add(match)
      end
    end

    current_matches
  end
end
