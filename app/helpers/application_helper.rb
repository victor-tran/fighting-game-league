module ApplicationHelper

  def current_year
    @current_year ||= Time.now.year
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Fighting Game League"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns true if matches are all accepted for the current round.
  def all_matches_accepted?(matches)
    matches_accepted = true

    matches.each do |match|
      if match.p1_accepted == false || match.p2_accepted == false
        matches_accepted = false
        break
      end
    end

    matches_accepted
  end

  # Returns W-L record for given set of matches.
  def WL_record(user, matches)
    wins = 0
    losses = 0

    matches.each do |match|
      if match.p1_accepted == true && match.p2_accepted == true
        if match.winner_id == user.id
          wins += 1
        else
          losses += 1
        end
      end
    end

    wins.to_s + "-" + losses.to_s
  end

  # Returns a hashmap of games, with each game containing the count for each
  # of it's characters.
  def count_characters

    # The hashmap that does the dirty work and will keep count of the
    # character occurrences.
    game_hashmap = {}

    # The hashmap that's key:value pairs will be game:[character,count] and
    # will be returned to the user at the end.
    final_hashmap = {}

    Game.all.each do |game|

      # Create an empty character hashmap for each game.
      game_hashmap[game] = {}

      # Set each character's count to 0 initially.
      game.characters.each do |character|
        game_hashmap[game][character] = 0
      end

      match_set = Match.where("game_id = ? AND p1_accepted = ? AND p2_accepted = ?", 
                               game.id, true, true)

      # Count each occurrence of a character's selection in a match.
      match_set.each do |match|
        unless match.p1_characters.empty?
          for j in 0..match.p1_characters.length-1
            game_hashmap[game][Character.find(match.p1_characters[j])] += 1
          end
        end
        unless match.p2_characters.empty?
          for j in 0..match.p2_characters.length-1
            game_hashmap[game][Character.find(match.p2_characters[j])] += 1
          end
        end
      end

      # Sort character_map in DESC order by count and add the array the final map.
      final_hashmap[game] = game_hashmap[game].to_a.sort_by{ |char| -char[1] }
    end
    final_hashmap
  end

  # Returns the amount for the most fight bucks bet on one match.
  def most_fight_bucks_bet_on_one_match
    match_hash = Hash.new
    match_hash[:amount] = 0

    Match.all.each do |match|
      current_bet_amount = match.bets.sum("wager_amount")
      if current_bet_amount > match_hash[:amount]
        match_hash[:match] = match
        match_hash[:amount] = current_bet_amount
      end
    end

    match_hash
  end

  # Returns the highest number of bets ever placed on one match.
  def highest_number_of_bets
    match_hash = Hash.new
    match_hash[:count] = 0

    Match.all.each do |match|
      current_bet_count = match.bets.count
      if current_bet_count > match_hash[:count]
        match_hash[:match] = match
        match_hash[:count] = current_bet_count
      end
    end

    match_hash
  end

  # Returns the most MP in a League
  def most_matches_played_in_a_league(game)
    league_hash = Hash.new
    league_hash[:mp] = 0
    League.where("game_id = ?", game.id).each do |league|
      
      current_MP_count = 0
      
      league.matches.each do |match|
        unless match.finalized_date == nil
          current_MP_count += 1
        end
      end

      if current_MP_count > league_hash[:mp]
        league_hash[:league] = league
        league_hash[:mp] = current_MP_count
      end
    end

    league_hash
  end

  # Return most wins throughout all games.
  def most_wins_all_games
    user_hash = Hash.new
    user_hash[:wins] = 0

    User.all.each do |user|
      current_user_wins = 0
      
      user.matches.each do |match|
        if match.winner_id == user.id && match.finalized_date != nil
          current_user_wins += 1
        end
      end

      if current_user_wins > user_hash[:wins]
        user_hash[:user] = user
        user_hash[:wins] = current_user_wins
      end
    end

    user_hash
  end

  # Returns a hash that contains the user that has the most amount of wins 
  # for a given game.
  def most_wins_per_game(game)
    user_hash = Hash.new
    user_hash[:wins] = 0

    User.all.each do |user|
      current_user_wins = 0

      user_matches = user.p1_matches.where("game_id = ?", game.id) +
                     user.p2_matches.where("game_id = ?", game.id)
      
      user_matches.each do |match|
        if match.winner_id == user.id && match.finalized_date != nil
          current_user_wins += 1
        end
      end

      if current_user_wins > user_hash[:wins]
        user_hash[:user] = user
        user_hash[:wins] = current_user_wins
      end
    end

    user_hash
  end

end