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

end