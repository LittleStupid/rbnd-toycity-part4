require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  # Your code goes here!l
  #brands = ["Crayola", "Lego", "Nintendo", "Fisher-Price", "Hasbro"]
  #product_names = ["crayons", "house", "video game", "kitchen", "toy car"]
  #prices = ["2.00", "14.50", "2.10", "99.99", "19.99"]

  10.times do
    # you will write the "create" method as part of your project
    Product.create( brand: Faker::Company.name,
                    name: Faker::Name.name,
                    price: Faker::Commerce.price )
  end
end
