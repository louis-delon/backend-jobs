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
      price_per_shift: worker['price_per_shift'],
      status: worker['status']
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

def compute_new_data
  data = {}
  data['workers'] = []
  @workers.map do |worker|
    worker_shifts = @shifts.select { |shift| worker.id == shift.user_id }
    price_computation(worker, worker_shifts)
    data['workers'] << { id: worker.id, price: worker.price }
  end
  data
end

def storing(data, file)
  File.open(file,'wb') do |file|
    file.write(JSON.generate(data))
  end
end

private

def price_computation(worker, shifts)
  shifts.each do |shift|
    if shift.weekend?
      worker.price_in_weekend
    else
      worker.price_in_week
    end
  end
end
