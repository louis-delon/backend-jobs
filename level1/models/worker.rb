class Worker
  attr_reader :id, :first_name, :price_per_shift
  attr_accessor :price

  def initialize(attributes = {})
    @id = attributes[:id]
    @first_name = attributes[:first_name]
    @price_per_shift = attributes[:price_per_shift]
    @price = 0
  end
end
