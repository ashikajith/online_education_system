require 'factory_girl'

FactoryGirl.define do
  #sequence for emails
  sequence :email do |n|
    "user#{n}@rubykitchen.in"
  end

  #first name
  sequence :first_name do |n|
    "user#{n}"
  end

  #School Name
  sequence :name do |n|
    "School#{n}"
  end

  #factory for creating Institution
  factory :institution do
    name "Institution 1"
    address "addresss"
    area "area"
    city "Cochin"
    state "Kerala"
    country "India"
    pincode "689302"
    phone "9123456780"
    email "email@gmail.com"
    website "http://rubykitchen.in"
    #callback for creating schools under this institution
    after(:create) do |institution, school|
      FactoryGirl.create_list(:school,50, institution_id:institution.id)
      #create mentors
      FactoryGirl.create_list(:user, 50, school_id:school.id, institution_id:school.institution.id,role:"mentor",scheme_id:"")
      #create Institution Admins
      FactoryGirl.create_list(:user, 1, institution_id:school.institution.id, role: "iadmin", scheme_id:"")
      #create institution staffs
      FactoryGirl.create_list(:user, 2, institution_id:school.institution.id, role: "iadmin", scheme_id:"")
    end
  end

  #factory for schools
  factory :school do
    name
    address "addresss"
    area "area"
    city "Cochin"
    state "Kerala"
    country "India"
    pincode "689302"
    landline "1234567890"
    mobile "9123456780"
    email "email@gmail.com"
    website "http://rubykitchen.in"
    #callback for createating users
    after(:create) do |school, n|
      #create students
      FactoryGirl.create_list(:user, 100, school_id:school.id, institution_id:school.institution.id)
      #create school admins
      FactoryGirl.create_list(:user, 1, school_id:school.id, institution_id:school.institution.id, role: "sadmin", scheme_id:"")
      #create School staffs
      FactoryGirl.create_list(:user, 2, school_id:school.id, institution_id:school.institution.id, role: "sstaff",scheme_id:"")
    end
  end

  #Factory for users
  factory :user do
    email
    password "mypassword"
    password_confirmation "mypassword"
    role  "student"
    scheme_id {Scheme.last.id}
    before(:create) do |user|
      user.skip_confirmation!
    end
  end
end

namespace :populate do
  desc "Seed the database users"
  task :users => :environment do
    FactoryGirl.create_list(:institution, 1)
  end
end