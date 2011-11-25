class WelcomeController < ApplicationController
  before_filter :get_fb_session

  def index
    @user = current_user
    render :action => 'home'
  end

  def test
    render :text => current_user.inspect, :layout => true
  end

end
