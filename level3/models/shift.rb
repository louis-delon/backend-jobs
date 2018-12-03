# model of Shift
class Shift
  attr_reader :user_id, :planning_id, :start_date, :id

  def initialize(attributes = {})
    @id = attributes[:id]
    @planning_id = attributes[:planning_id]
    @user_id = attributes[:user_id]
    @start_date = attributes[:start_date]
  end

  def shift_day
    Date.parse(@start_date).strftime('%A').downcase
  end

  def weekend?
    shift_day == 'sunday' || shift_day == 'saturday'
  end

end
