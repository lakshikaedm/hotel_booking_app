class RoomModelsController < ApplicationController
before_action :require_login, except: [:index, :show]
before_action :set_room, only: [:show, :edit, :update, :destroy]
before_action :authorize_owner!, only: [:edit, :update, :destroy]

  AREA_RULES = {
    "tokyo"   => { include: ["Tokyo", "東京"],   exclude: [] },
    "kyoto"   => { include: ["Kyoto", "京都"],   exclude: ["東京都"] },
    "osaka"   => { include: ["Osaka", "大阪"],   exclude: [] },
    "sapporo" => { include: ["Sapporo", "札幌"], exclude: [] }
  }.freeze

  def catalog
    @room_models = RoomModel.all

    if params[:area].present?
      key = params[:area].to_s.downcase
      rules = AREA_RULES[key]
      if rules
        t = RoomModel.arel_table
        inc_ors = rules[:include].map { |w| t[:address].matches("%#{w}%") }
        inc_cond = inc_ors.reduce { |acc, c| acc.or(c) }
        @room_models = @room_models.where(inc_cond)
        rules[:exclude].each do |w|
          @room_models = @room_models.where.not(t[:address].matches("%#{w}%"))
        end
      end
    end

    if params[:q].present?
      q = params[:q].to_s.strip
      if (area_key = area_key_for(q))
        rules = AREA_RULES[area_key]
        t = RoomModel.arel_table
        inc_ors = rules[:include].map { |w| t[:address].matches("%#{w}%") }
        inc_cond = inc_ors.reduce { |acc, c| acc.or(c) }
        @room_models = @room_models.where(inc_cond)
        rules[:exclude].each do |w|
          @room_models = @room_models.where.not(t[:address].matches("%#{w}%"))
        end
      else
        t = RoomModel.arel_table
        like = "%#{q}%"
        conds = [ t[:title].matches(like), t[:description].matches(like), t[:address].matches(like) ]
        @room_models = @room_models.where(conds.reduce { |acc, c| acc.or(c) })
      end
    end

    @room_models = @room_models.order(created_at: :desc).page(params[:page]).per(12)
  end

  def index
    @room_models = RoomModel.order(created_at: :desc).page(params[:page]).per(12)
  end

  def show;
  end

  def new
    @room_model = current_user.room_models.new
  end

  def create
    @room_model = current_user.room_models.new(room_params)
    if @room_model.save
      redirect_to @room_model, notice: '施設を作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit;
  end

  def update
    if @room_model.update(room_params)
      redirect_to @room_model, notice: '施設を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room_model.destroy
    redirect_to room_models_path, notice: '施設を削除しました。'
  end

  private
  def set_room
    @room_model = RoomModel.find(params[:id])
  end

  def authorize_owner!
    redirect_to room_models_path, alert: '権限がありません。' unless @room_model.user_model_id == current_user&.id
  end

  def room_params
    params.require(:room_model).permit(:title, :description, :fee, :address, :facility_image)
  end

  def area_key_for(term)
    down = term.to_s.downcase
    AREA_RULES.each do |key, rules|
      return key if rules[:include].any? { |w| w.downcase == down }
    end
    nil
  end
end
