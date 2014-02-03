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

  # Returns "first_name 'alias' last_name" of given User
  def full_name(user)
  	user.first_name + " '" + user.alias + "' " + user.last_name
  end
end