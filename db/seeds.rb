# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


#create a Super User
user = User.create!({email:'manu@rubykitchen.org',password:'mypassword',
                     password_confirmation:'mypassword', role:"owner"})

user_details = user.build_user_detail(first_name:'Manu S',last_name:'Ajith',
																			dob:(Time.now-(23.years)).to_date,
																			address:'Asset Life Space',city:'Cochin',
																			state:'Kerala',country:'India',pincode:'682309',
																			mobile:'9447786299',landline:'04842114850')
user_details.save
user.confirm!

#create Subjects
physics = Subject.create!(name:'Physics')
chemistry = Subject.create!(name:'Chemistry')
maths = Subject.create!(name:'Maths')
biology = Subject.create!(name:'Biology')

#create Schemes
engineering = Scheme.create!(name:'Engineering',subject_ids:[physics.id,chemistry.id,maths.id])
medical = Scheme.create!(name:'Medical',subject_ids:[physics.id,chemistry.id,biology.id])
both = Scheme.create!(name:'Both',subject_ids:[physics.id,chemistry.id,maths.id,biology.id])

#create Question Tags
QuestionTag.create!(name:'Easy')
QuestionTag.create!(name:'Medium')
QuestionTag.create!(name:'Tough')
