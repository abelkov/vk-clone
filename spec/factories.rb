FactoryGirl.define do
  factory :user do
    first_name     "Alexey"
    last_name      "Belkov"
    email    			 "knots@ya.ru"
    password 			 "secret"
    password_confirmation "secret"
  end
end