module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end
end
