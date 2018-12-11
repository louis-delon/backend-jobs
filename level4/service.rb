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

def compute_new_data(data = {})
  data['workers'] = []
  @workers.map do |worker|
    shifts_by_user = @shifts.select { |shift| worker.id == shift.user_id }
    price_computation(worker, shifts_by_user)
    data['workers'] << { id: worker.id, price: worker.price }
  end
  compute_commission(data)
  data
end

def storing(data, file)
  File.open(file, 'wb') do |f|
    f.write(JSON.generate(data))
  end
end

private

def price_computation(worker, shifts)
  # compute price for all shift that belong a worker
  shifts.each do |shift|
    shift.weekend? ? worker.price_in_weekend : worker.price_in_week
  end
end

def compute_commission(data)
  data['commission'] = {}
  @shifts_from_interim = []
  set_commission
  data['commission']['pdg_fee'] = @total_commission
  data['commission']['interim_shifts'] = @shifts_from_interim.count
end

def set_commission
  #compute commission according to worker status
  @total_commission = 0
  @workers.map do |worker|
    worker.interim? ? interim_commission(worker) : normal_commission(worker)
  end
end

def interim_commission(worker)
  @shifts_from_interim = current_worker_shifts(worker)
  @total_commission += (@shifts_from_interim.count * 80) + (worker.price * 0.05)
end

def normal_commission(worker)
  @total_commission += worker.price * 0.05
end

def current_worker_shifts(worker)
  @shifts.select { |shift| worker.id == shift.user_id }
end
