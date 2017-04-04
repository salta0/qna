FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :name do |n|
    "Name #{n}"
  end

  factory :user do
    email
    name
    location "Some Location"
    description "Some Description"
    password '12345678'
    password_confirmation '12345678'
  end
end
