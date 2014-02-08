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

  # Returns "first_name 'alias' last_name" of given User.
  def full_name(user)
  	user.first_name + " '" + user.alias + "' " + user.last_name
  end

  # Returns a list of all pending matches for user.
  def pending_matches(matches, user)
    
    # Set of matches to be returned
    pending_matches = Set.new

    matches.each do |match|
      if user.id == match.p1_id && match.p1_accepted == false
        pending_matches.add(match)
      elsif user.id == match.p2_id && match.p2_accepted == false
        pending_matches.add(match)
      end
    end

    pending_matches
  end

  # Returns overall W-L fighter history.

  # Returns current match streak.

  # Returns longest win streak ever.

  # Returns league W-L history.
end