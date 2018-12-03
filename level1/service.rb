require 'json'
require_relative'./models/shift'
require_relative'./models/worker'
require 'pry-byebug'

def parsing(file)
  serialized_data = File.read(file)
  JSON.parse(serialized_data)
end

def create_workers(data)
  @workers = data['workers'].map do |worker|
    Worker.new(
      id: worker['id'],
      first_name: worker['first_name'],
      price_per_shift: worker['price_per_shift']
    )
  end
end

def create_shifts(data)
  @shifts = data['shifts'].map do |shift|
    Shift.new(
      id: shift['id'],
      planning_id: shift['planning_id'],
      user_id: shift['user_id'],
      start_date: shift['start_date']
    )
  end
end

def new_data
  data = {}
  data['workers'] = []
  @workers.map do |worker|
    number_of_shifts = @shifts.select { |shift| worker.id == shift.user_id }.count
    worker.price = number_of_shifts * worker.price_per_shift
    data['workers'] << { id: worker.id, price: worker.price }
  end
  data
end

def storing(data, file)
  File.open(file,'wb') do |file|
    file.write(JSON.generate(data))
  end
end
