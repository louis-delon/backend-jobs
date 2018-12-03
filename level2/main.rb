require 'json'
require 'awesome_print'
require_relative './service'

data = parsing('data.json')
create_workers(data)
create_shifts(data)
data = new_data
storing(data,'test.json')
