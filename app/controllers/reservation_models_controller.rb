class ReservationModelsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :require_owner!, only: [:show, :edit, :update, :destroy]

  def index
    @reservation_models = current_user.reservation_models.includes(:room_model).order(created_at: :desc)
  end

  def show
  end

  def new
    @room_model = RoomModel.find(params[:room_model_id])
    @reservation_model = current_user.reservation_models.new(room_model: @room_model)
  end

  def create
    @room_model = RoomModel.find(params[:room_model_id])
    @reservation_model = current_user.reservation_models.new(reservation_params.merge(room_model: @room_model))
    
    if @reservation_model.save
      redirect_to @reservation_model, notice: '予約を確定しました。'
    else
      flash.now[:alert] =  '予約内容にエラーがあります。'
      render 'room_models/show', status: :unprocessable_entity
    end
  end

  def edit;
  end

  def update
    if @reservation_model.update(reservation_params)
      redirect_to @reservation_model, notice: '予約を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation_model.destroy
    redirect_to reservation_models_path, notice: '予約を削除しました。'
  end

  private

  def set_reservation
    @reservation_model = ReservationModel.find(params[:id])
  end

  def require_owner!
    redirect_to reservation_models_path, alert: '権限がありません。' unless @reservation_model.user_model_id == current_user.id
  end
  
  def reservation_params
    params.require(:reservation_model).permit(:check_in, :check_out, :guests)
  end
end
