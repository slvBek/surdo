class ApplicationController < ActionController::Base
    before_action :init_session

  private

  def init_session
    session[:liked_posts] ||= []
  end
end
