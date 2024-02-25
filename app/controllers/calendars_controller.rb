class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    post = Plan.create(date: params[:plan][:date], plan: params[:plan][:plan])
    redirect_to action: :index
  end  

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day : 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
    
      wday_num = (@todays_date + x).wday 
      if wday_num >= 7
        wday_num = wday_num -7
      end    

      days = { 
        month: (@todays_date + x).month,  # <= plan_date.month を (@todays_date + x).month に変更
        date: (@todays_date + x).day,   # <= plan_date.day を (@todays_date + x).day に変更
        plans: today_plans, 
        wday: wdays[wday_num]
      }
      @week_days.push(days)
    end
  end
end
