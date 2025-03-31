class Auth0Controller < ApplicationController
  skip_before_action :authenticate_user!, only: [:login, :callback, :failure]

  def login
    redirect_to "https://#{ENV['AUTH0_DOMAIN']}/authorize?" + {
      client_id: ENV['AUTH0_CLIENT_ID'],
      redirect_uri: auth_auth0_callback_url,
      response_type: 'code',
      scope: 'openid profile email'
    }.to_query, allow_other_host: true
  end

  def callback
    # Exchange code for token
    token_response = HTTP.post("https://#{ENV['AUTH0_DOMAIN']}/oauth/token", json: {
      client_id: ENV['AUTH0_CLIENT_ID'],
      client_secret: ENV['AUTH0_CLIENT_SECRET'],
      code: params[:code],
      grant_type: 'authorization_code',
      redirect_uri: auth_auth0_callback_url
    })

    if token_response.status.success?
      token_data = token_response.parse
      # Get user info
      user_response = HTTP.auth("Bearer #{token_data['access_token']}")
                         .get("https://#{ENV['AUTH0_DOMAIN']}/userinfo")

      if user_response.status.success?
        userinfo = user_response.parse
        
        # Find or create user with all available information
        user = User.find_or_create_by(auth0_id: userinfo['sub']) do |u|
          u.email = userinfo['email']
          u.name = userinfo['name']
          u.picture = userinfo['picture']
          u.locale = userinfo['locale']
        end

        # Update user information if it has changed
        user.update(
          email: userinfo['email'],
          name: userinfo['name'],
          picture: userinfo['picture'],
          locale: userinfo['locale']
        )

        # Store user id in session
        session[:user_id] = user.id
        redirect_to root_path
      else
        redirect_to root_path, alert: 'Failed to get user info'
      end
    else
      redirect_to root_path, alert: 'Failed to get access token'
    end
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed. Please try again.'
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
