class FeedbackOptionsController < ApplicationController
    def index
        respond_to do |format|
            if current_user.can_submit_feedback
                options = FeedbackOption.last(3)
                format.json { render json: options, status: :ok }
            else
                format.json { render json: { error: 'bad' }, status: :forbidden }
            end
        end
    end
end
