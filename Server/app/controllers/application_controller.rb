class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 例外処理
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
  	#render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  	render nothing: true, status: 404
  end

  def render_500
  	render nothing: true, status: 500
  end
end
