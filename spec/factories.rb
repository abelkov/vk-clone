FactoryGirl.define do
  factory :user do
    first_name   "Alexey"
    last_name    "Belkov"
    email    	   "knots@ya.ru"
    password 	   "secret"
    password_confirmation "secret"
    status       "You're mocking a global object. What the fuck?"
    hometown     "Pskov"
    sex 		     "Male"
    relationship "Single"
    birthday 	   Date.new(1992, 2, 18)
    
  end

  factory :language do
    factory :english do
      name "English"
    end
    factory :russian do
      name "Russian"
    end
  end
end