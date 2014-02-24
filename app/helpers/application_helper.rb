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

  # Returns longest win streak ever.

  # Returns league W-L history.
end