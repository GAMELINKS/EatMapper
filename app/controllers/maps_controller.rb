require 'exifr'
require 'exifr/jpeg'

class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new]
  PER = 10

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.all.page(params[:page]).per(PER)
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
  end

  # GET /maps/new
  def new
    @map = Map.new
  end

  # GET /maps/1/edit
  def edit
  end

  # POST /maps
  # POST /maps.json
  def create
    @map = Map.new(map_params)
    @map.user_id = current_user.id

    respond_to do |format|
      if @map.save
        image_path = "./public#{@map.image.to_s}"
        @exif = EXIFR::JPEG.new(image_path.to_s)
        @map.update(:longitude => @exif.gps.class == nil.class ? nil : @exif.gps.longitude, 
                    :latitude => @exif.gps.class == nil.class ? nil : @exif.gps.latitude, 
                    :date => @exif.date_time_original.class == nil.class ? nil : @exif.date_time_original)

        format.html { redirect_to @map, notice: 'Map was successfully created.' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)

        image_path = "./public#{@map.image.to_s}"
        @exif = EXIFR::JPEG.new(image_path.to_s)
        @map.update(:longitude => @exif.gps.class == nil.class ? nil : @exif.gps.longitude, 
                    :latitude => @exif.gps.class == nil.class ? nil : @exif.gps.latitude, 
                    :date => @exif.date_time_original.class == nil.class ? nil : @exif.date_time_original)

        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.require(:map).permit(:title, :about, :date, :image, :latitude, :longitude)
    end

    def require_login
      if !user_signed_in?
        flash[:error] = "ログインしてください！"
        redirect_to user_mastodon_omniauth_authorize_path
      end
    end
end
