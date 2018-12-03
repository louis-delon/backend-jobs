require 'json'
require 'awesome_print'
require_relative './service'

data = parsing('data.json')
create_workers(data)
create_shifts(data)
new_data = compute_new_data
storing(new_data, 'test.json')
