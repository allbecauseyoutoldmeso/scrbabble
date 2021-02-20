4.times do |num|
  User.create(name: "user_#{num + 1}", password: 'password')
end
