module FacebookHelper

  def fb_auth_url(options={})
    redirect_uri = options[:redirect_uri] || fb_canvas_page_url
    scope = options[:scope] || FB_APP_SCOPE
    display = options[:display] || 'page'
    "https://www.facebook.com/dialog/oauth?client_id=#{FB_APP_ID}&redirect_uri=#{redirect_uri}&scope=#{scope}&display=#{display}" 
  end  

  def fb_canvas_page_url
    "https://apps.facebook.com/#{FB_APP_NAMESPACE}/"
  end

  def fb_page_tab_url(page_id)
    "http://www.facebook.com/pages/#{page_id}?sk=app_#{FB_APP_ID}"
    "https://www.facebook.com/pages/#{page_id}"
  end

  def fb_init(async=true)
    if async
      <<-CODE
      <div id="fb-root"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/ko_KR/all.js#xfbml=1&appId=#{FB_APP_ID}";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>
      CODE
    else
      <<-CODE
      <div id="fb-root"></div>
      <script src="http://connect.facebook.net/en_US/all.js"></script>
      <script>
          FB.init({ 
              appId:'#{FB_APP_ID}', cookie:true, 
              status:true, xfbml:true, oauth:true
          });
      </script>
      CODE
    end
  end

  # You can specify the picture size you want with the type argument, 
  # which should be one of square (50x50), small (50 pixels wide, variable height), 
  # and large (about 200 pixels wide, variable height): 
  # http://graph.facebook.com/100001052717216/picture?type=large.

  def fb_profile_image_url(fb_user_id, type=:square)
    "https://graph.facebook.com/#{fb_user_id}/picture?type=#{type.to_s}"
    "https://graph.facebook.com/#{@user['user_id']}/picture?type=normal&access_token=#{@user['access_token']}"
  end


  def fb_redirect_to(url)
    render :text => "<script>top.location.href='#{url}'</script>"
  end  

end