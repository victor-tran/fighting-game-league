module LeaguesHelper

  # Returns an array sorted by Wins that contains each user's W-L-MP.
  def generate_user_standings(match_set)

    # Set all user's W-L values to 0-0 and set matches played to 0.
    user_hashmap = {}
    @league.users.each do |user|
      user_hashmap[user] = [0,0,0]
    end

    # Calculate each user's W-L-MP
    match_set.each do |match|

      # Only calculate if match has been accepted by p1 & p2.
      if match.p1_accepted == true && match.p2_accepted == true
        if match.p1_id == match.winner_id
          user_hashmap[match.p1][0] += 1
          user_hashmap[match.p1][2] += 1

          user_hashmap[match.p2][1] += 1
          user_hashmap[match.p2][2] += 1
        else
          user_hashmap[match.p2][0] += 1
          user_hashmap[match.p2][2] += 1

          user_hashmap[match.p1][1] += 1
          user_hashmap[match.p1][2] += 1
        end

        # Remove the match from match_set
        match_set.delete(match)
      end
    end
    
    # Convert hashmap to an array that is sorted by Wins and then by MP.
    user_hashmap.to_a.sort_by{ |user| [ -user[1][0], -user[1][2] ] }
  end
end
