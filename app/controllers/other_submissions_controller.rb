class OtherSubmissionsController < ApplicationController
    def create
        other_submission = OtherSubmission.new(other_submission_params)

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
            params.require(:other_submissions).permit(:user_id, :summary)
        end
end
