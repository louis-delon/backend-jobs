class Worker
  attr_reader :id, :first_name, :price_per_shift, :status
  attr_accessor :price

  def initialize(attributes = {})
    @id = attributes[:id]
    @first_name = attributes[:first_name]
    @status = attributes[:status]
    @price = 0
  end

  def medic?
    @status == 'medic'
  end
end
