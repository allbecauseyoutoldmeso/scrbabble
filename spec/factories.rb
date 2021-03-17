FactoryBot.define do
  factory :board do
  end

  factory :game do
  end

  factory :player do
    user factory: :user
  end

  factory :premium do
  end

  factory :square do
  end

  factory :tile do
  end

  factory :tile_bag do
  end

  factory :tile_rack do
  end

  factory :turn do
  end

  factory :user do
    name { 'user' }
    password { 'password' }
  end
end
