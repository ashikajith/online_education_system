require 'factory_girl'

FactoryGirl.define do
  sequence :order do |n|
    "#{n}"
  end

  #factory for creating Units
  factory :unit do
    sequence(:name) {|n| "Unit #{n}" }
    days 30
    order
    subject_id {Subject.all.map(&:id).sample}
    before(:create) do |unit|
      unit.name += unit.subject.name
    end
    #create question papers
    after(:create) do |unit|
      FactoryGirl.create_list(:question_paper,200, unit_id:unit.id, subject_id:unit.subject.id)
    end

    
  end

  sequence :questions do |n|
    "Question #{n}"
  end

  factory :question_paper do
    sequence(:name) {|n| "Question Paper #{n}" }
    type "Daily"
    #create questions
    after(:create) do |paper|
      FactoryGirl.create_list(:question,200, unit_id:paper.unit.id, subject_id:paper.subject.id)
    end
  end

  factory :question do
    questions
    option1 "option1"
    option2 "option2"
    option3 "option3"
    option4 "option4"
    option5 "option5"
    correct_option  {["option1","option2","option3","option4","option5"].sample}
    explanation "This is test question"
    question_tag_ids {QuestionTag.all.map(&:id).sample}
  end

end
namespace :populate do
  desc "Seed the database questions"
  task :questions => :environment do
    FactoryGirl.create_list(:unit, 100)
  end
end