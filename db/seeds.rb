# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# #Only used for testing in rails c and rails dbconsole

# BulkDiscount.destroy_all

# bulk_discount_1 = BulkDiscount.create!(title: '15% off of 10 or more', percentage_discount: 15, quantity_threshold: 10, merchant_id: 1)
# bulk_discount_2 = BulkDiscount.create!(title: '10% off of 5 or more', percentage_discount: 10, quantity_threshold: 5, merchant_id: 1)