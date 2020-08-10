class FeedbackOptionsController < ApplicationController
    def index
        options = FeedbackOption.all

        respond_to do |format|
            format.json { render json: options, status: :ok }
        end
    end
end
