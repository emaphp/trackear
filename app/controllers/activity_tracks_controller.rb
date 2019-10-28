# frozen_string_literal: true

class ActivityTracksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_currently_active_contract, only: %i[show create edit update destroy]
  before_action :set_activity_track, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /activity_tracks
  # GET /activity_tracks.json
  def index
    @activity_tracks = ActivityTrack.all
  end

  # GET /activity_tracks/1
  # GET /activity_tracks/1.json
  def show; end

  # GET /activity_tracks/new
  def new
    @activity_track = ActivityTrack.new
  end

  # GET /activity_tracks/1/edit
  def edit; end

  # POST /activity_tracks
  # POST /activity_tracks.json
  def create
    @activity_track = @active_contract.activity_tracks.new(activity_track_params)

    respond_to do |format|
      if @activity_track.save
        format.html { redirect_to @project, notice: 'Activity track was successfully created.' }
        format.json { render :show, status: :created, location: @activity_track }
      else
        format.html { render :new }
        format.json { render json: @activity_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_tracks/1
  # PATCH/PUT /activity_tracks/1.json
  def update
    respond_to do |format|
      if @activity_track.update(activity_track_params)
        format.html { redirect_to @project, notice: 'Activity track was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @activity_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_tracks/1
  # DELETE /activity_tracks/1.json
  def destroy
    @activity_track.destroy
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Activity track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_currently_active_contract
    @project = current_user.projects.friendly.find(params[:project_id])
    @active_contract = current_user.currently_active_contract_for(@project)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_activity_track
    @activity_track = @active_contract.activity_tracks.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_track_params
    params.require(:activity_track).permit(:from, :to, :description)
  end
end
