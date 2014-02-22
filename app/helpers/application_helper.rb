module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Fighting Game League"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns a list of all pending matches for user.
  def pending_matches(matches, user)

    # Set of matches to be returned
    pending_matches = Set.new

    matches.each do |match|

      # If user is p1 or p2 and the match is for the current round in the league
      if user.id == match.p1_id || user.id == match.p2_id
        if match.round_number == League.find(match.league_id).current_round

          # Add to pending matches if character hasn't been set yet.
          if user.id == match.p1_id && match.p1_character == nil
            pending_matches.add(match)
          elsif user.id == match.p2_id && match.p2_character == nil
            pending_matches.add(match)

          # Add to pending matches if date has not been set yet.
          elsif match.match_date == nil
            pending_matches.add(match)

          # Add to pending matches if matches have NOT been accepted by user yet.
          elsif user.id == match.p1_id && match.p1_accepted == false
            pending_matches.add(match)
          elsif user.id == match.p2_id && match.p2_accepted == false
            pending_matches.add(match)
          end

        end
      end
    end

    pending_matches
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

  # Returns longest win streak ever.

  # Returns league W-L history.
end