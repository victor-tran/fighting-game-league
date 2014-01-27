module ApplicationHelper
  # Returns "first_name 'alias' last_name" of given User
  def full_name(user)
    user.first_name + " '" + user.alias + "' " + user.last_name
  end
end
