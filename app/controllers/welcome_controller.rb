class WelcomeController < ApplicationController
  before_filter :get_fb_session, :only => [:index]

  def index
    @user = current_user
    render :action => 'home'
  end

end
