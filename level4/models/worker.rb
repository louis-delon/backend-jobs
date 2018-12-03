# Model Worker
class Worker
  attr_reader :id, :first_name, :status
  attr_accessor :price

  SHIFT_PRICE = {
    medic: 270,
    interne: 126,
    interim: 480
  }.freeze

  def initialize(attributes = {})
    @id = attributes[:id]
    @first_name = attributes[:first_name]
    @status = attributes[:status]
    @price = 0
  end

  def medic?
    @status == 'medic'
  end

  def interne?
    @status == 'interne'
  end

  def interim?
    @status == 'interim'
  end

  def price_in_weekend
    @price +=
      if medic?
        SHIFT_PRICE[:medic] * 2
      elsif interne?
        SHIFT_PRICE[:interne] * 2
      else
        SHIFT_PRICE[:interim] * 2
      end
  end

  def price_in_week
    @price +=
      if medic?
        SHIFT_PRICE[:medic]
      elsif interne?
        SHIFT_PRICE[:interne]
      else
        SHIFT_PRICE[:interim]
      end
  end
end
