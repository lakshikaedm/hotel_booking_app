class SearchController < ApplicationController
  AREA_RULES = {
    "tokyo"   => { include: ["Tokyo", "東京"],   exclude: [] },
    "osaka"   => { include: ["Osaka", "大阪"],   exclude: [] },
    "kyoto"   => { include: ["Kyoto", "京都"],   exclude: ["東京都"] },
    "sapporo" => { include: ["Sapporo", "札幌"], exclude: [] }
  }.freeze

  def index
    @area = params[:area]
    @q    = params[:q]

    rel = RoomModel.all

    if @area.present?
      key = @area.to_s.downcase
      rules = AREA_RULES[key]
      if rules
        t = RoomModel.arel_table
        inc_ors  = rules[:include].map { |w| t[:address].matches("%#{w}%") }
        if inc_ors.any?
          rel = rel.where(inc_ors.reduce { |acc, c| acc.or(c) })
        end
        rules[:exclude].each do |w|
          rel = rel.where.not(t[:address].matches("%#{w}%"))
        end
      end
    end

    if @q.present?
      q = @q.to_s.strip
      t = RoomModel.arel_table
      like = "%#{q}%"
      cond = t[:title].matches(like)
               .or(t[:description].matches(like))
               .or(t[:address].matches(like))
      rel = rel.where(cond)
    end

    @room_models = rel.order(created_at: :desc).includes(:user_model).page(params[:page]).per(12)
    @total = @room_models.size
  end
end
