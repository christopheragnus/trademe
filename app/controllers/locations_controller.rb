class LocationsController < ApplicationController
before_action :set_location, only: [:show, :edit, :update, :destroy]
before_action :set_task, only:[:new, :create]


  def index
    @task = Task.find(params[:task_id])
    if params[:search].present?
      @locations = Location.near(params[:search], 50, :order => 'distance')
    else
      @locations = Location.all
    end
  end

  def show
    @task = Task.find(params[:task_id])
    # @location = Location.find(params[:id])
    @bids = Bid.where(task_id: @task.id).order("created_at DESC")
  end

  def new
    @location = Location.new
  end

  def edit
  end

  def create
    @task = Task.find(params[:task_id])
    @location = Location.new(allowed_params)
    @location.task_id = @task.id

    if @location.save
      redirect_to task_location_path(@task,@location), :notice => "Successfully created location."
    else
      render :new
    end
  end

  def edit
    # @location = Location.find(params[:id])
  end

  def update
    @task = Task.find(params[:task_id])
    # @location = Location.find(params[:id])
    if @location.update_attributes(allowed_params)
      redirect_to task_location_path(@task,@location), :notice  => "Successfully updated location but please check your address if it's correct."
    else
      render :edit
    end
  end

  def destroy
    # @location = Location.find(params[:id])
    @location.destroy

    redirect_to task_locations_url, :notice => "Successfully destroyed location."
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end

  def allowed_params
    params.require(:location).permit(:id, :address, :latitude, :longitude)
  end

  def set_task
    @task = Task.find(params[:task_id])
  end
end
