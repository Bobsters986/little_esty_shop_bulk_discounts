# Little Esty Shop Bulk Discounts

## Background and Description
"Little Esty Shop" is a solo project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory, utilize CRUD functionality for bulk discounts, the calculations on a merchant's revenue and fulfill customer invoices.

## Learning Goals
- Practice designing a normalized database schema and defining model relationships
- Utilize advanced routing techniques including namespacing to organize and group like functionality together.
- Utilize advanced active record techniques to perform complex database queries
- Practice consuming a public API while utilizing POROs as a way to apply OOP principles to organize code
- Design an Object Oriented Solution to a problem
- Practice algorithmic thinking

## Requirements
- must use Rails 5.2.x
- must use PostgreSQL

## Setup
This project requires Ruby 2.7.4.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

## Summary of work completed
* Create an application where a small business could manage their customer data and web page
* Add ability for a merchant to add bulk discounts, and create the calculations necessary to display them
* Create advanved routing techniques like namespace and resources
* Work with many to many and one to many relationships to create a normalized database
* Create complex active record queries to extract specific information from our database
* Consume an API in order to display the next 3 US Holidays

## Potential Future Refactor
* Possibly utilize FactoryBot gem to create normalized test data across all test files
* Identify more partials, particularly the new/edit form

## Authors 
[Bobby Luly](https://github.com/Bobsters986)