class CustomApiController < ApplicationController
    before_action :authenticate_with_api_key
    before_action :find_issue
    before_action :check_visibility
  
    def allowed_statuses
      statuses = @issue.new_statuses_allowed_to(User.current)
  
      render json: {
        issue_id: @issue.id,
        current_status: @issue.status.name,
        allowed_next_statuses: statuses.map { |s| { id: s.id, name: s.name } }
      }
    end
  
    private
  
    def authenticate_with_api_key
      api_key = request.headers['X-Redmine-API-Key'] || params[:key]
      user = User.find_by_api_key(api_key)
  
      if user
        User.current = user
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  
    def find_issue
      @issue = Issue.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Issue not found' }, status: :not_found
    end
  
    def check_visibility
      unless @issue.visible?(User.current)
        render json: { error: 'Access denied' }, status: :forbidden
      end
    end
  end
  