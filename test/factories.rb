require 'factory_girl'

Factory.define :show do |s|
  s.sequence( :name ){|n| "Show #{n}"}
end

Factory.define :episode do |e|
  e.sequence( :filename ){|n| "Episode_#{n / 5}x#{n % 5}.avi"}
  e.association :show
end

