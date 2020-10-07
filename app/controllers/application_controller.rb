class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :set_category
  protect_from_forgery with: :exception

  private

  def set_category
    @parents = Category.all.order("id ASC").limit(13)
  end

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

end

