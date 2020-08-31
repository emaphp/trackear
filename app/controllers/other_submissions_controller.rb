class OtherSubmissionsController < ApplicationController
    before_action :authenticate_user!

    def create
        other_submission = current_user.other_submissions.new(other_submission_params)

        respond_to do |format|
            if other_submission.save
                format.json { head :no_content, status: :ok } 
            else
                format.json { render json: other_submission.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def other_submission_params
            params.require(:other_submission).permit(:user_id, :summary)
        end
end
