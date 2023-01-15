class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, if: -> { params[:controller] != "policy" }

  protected

  def html_request?
    request.format.html?
  end
end