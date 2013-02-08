class ApplicationController < ActionController::Base
  protect_from_forgery
  protected

  def current_user
    return unless session[:user_id]

    begin
      @current_user ||= User.find(session[:user_id])
    rescue
      nil
    end
  end

  helper_method :current_user

  def logged_in?
    current_user.is_a? User
  end

  helper_method :logged_in?

  def require_login
    unless logged_in?
      session[:original_uri] = request.url
      flash[:error] = "You must be logged in to access this page."
      redirect_to new_session_path
    end
  end

  helper_method :require_login

  def has_fsa?
    if current_user.familysearch_account.nil?
      return false
    else
      return true
    end
  end

  helper_method :has_fsa?

  def fsa_connected?
    if logged_in? && has_fsa?
      return current_user.familysearch_account.fetch_session_id?
    end
    return false
  end

  helper_method :fsa_connected?
end
