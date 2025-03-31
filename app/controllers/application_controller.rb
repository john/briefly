class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Auth0Concern
  helper_method :current_user, :user_signed_in?

  before_action :authenticate_user!

  private

  # def current_user
  #   if session[:user_id].is_a?(String)
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   else
  #     super
  #   end
  # end
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to "/auth/login"
    end
  end
end
