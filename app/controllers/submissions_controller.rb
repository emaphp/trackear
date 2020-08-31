class SubmissionsController < ApplicationController
    before_action :authenticate_user!

    def create
        submission = current_user.submissions.new(submission_params)

        respond_to do |format|
            if submission.save
                format.json { head :no_content, status: :ok } 
            else
                format.json { render json: submission.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def submission_params
            params.require(:submission).permit(:user_id, :feedback_option_id) 
        end
end
