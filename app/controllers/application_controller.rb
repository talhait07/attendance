class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    User.first
  end

  def check_permission
    if !session[:user] || (session[:user] && !session[:user].is?(:admin))
      redirect_to root_url, :notice => 'You have not enough permission to access' and return
    end
  end

end
