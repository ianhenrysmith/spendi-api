FactoryGirl.define do
  factory :activity do
    description       { Faker::Commerce.product_name  }
    amount            { Faker::Commerce.price }
  end
end
