# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# role.create name: 'event create'
# role.create name: 'event read'
# role.create name: 'event update'
# role.create name: 'event delete'
# role.create name: 'event staffing'

Rating.create(number: 0,  short_name: 'NA',  long_name: 'None')
Rating.create(number: 1,  short_name: 'OBS', long_name: 'Observer')
Rating.create(number: 2,  short_name: 'S1',  long_name: 'Student 1')
Rating.create(number: 3,  short_name: 'S2',  long_name: 'Student 2')
Rating.create(number: 4,  short_name: 'S3',  long_name: 'Senior Student')
Rating.create(number: 5,  short_name: 'C1',  long_name: 'Controller')
Rating.create(number: 6,  short_name: 'C2',  long_name: 'Controller 2')
Rating.create(number: 7,  short_name: 'C3',  long_name: 'Senior Controller')
Rating.create(number: 8,  short_name: 'I1',  long_name: 'Instructor')
Rating.create(number: 9,  short_name: 'I2',  long_name: 'Instructor 2')
Rating.create(number: 10, short_name: 'I3',  long_name: 'Senior Instructor')
Rating.create(number: 11, short_name: 'SUP', long_name: 'Supervisor')
Rating.create(number: 12, short_name: 'ADM', long_name: 'Administrator')

Permission.create name: 'airport create'
Permission.create name: 'airport read'
Permission.create name: 'airport update'
Permission.create name: 'airport delete'

Permission.create name: 'certification create'
Permission.create name: 'certification read'
Permission.create name: 'certification update'
Permission.create name: 'certification delete'

Permission.create name: 'endorsement create'
Permission.create name: 'endorsement read'
Permission.create name: 'endorsement update'
Permission.create name: 'endorsement delete'

Permission.create name: 'event create'
Permission.create name: 'event read'
Permission.create name: 'event update'
Permission.create name: 'event delete'

Permission.create name: 'event signup create'
Permission.create name: 'event signup read'
Permission.create name: 'event signup update'
Permission.create name: 'event signup delete'

Permission.create name: 'event pilot signup create'
Permission.create name: 'event pilot signup read'
Permission.create name: 'event pilot signup update'
Permission.create name: 'event pilot signup delete'

Permission.create name: 'feedback create'
Permission.create name: 'feedback read'
Permission.create name: 'feedback read published'
Permission.create name: 'feedback update'
Permission.create name: 'feedback delete'

Permission.create name: 'position create'
Permission.create name: 'position read'
Permission.create name: 'position update'
Permission.create name: 'position delete'

Permission.create name: 'user create'
Permission.create name: 'user read'
Permission.create name: 'user update'
Permission.create name: 'user delete'

# Default Groups and permissions
Group.create name: 'public',
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'guest',
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'visiting controller',
             atc: true,
             visiting: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'controller',
             atc: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'mentor',
             atc: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'instructor',
             atc: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement create'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'webmaster',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport create'),
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'airport update'),
                 Permission.find_by(name: 'airport delete'),
                 Permission.find_by(name: 'certification create'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'certification update'),
                 Permission.find_by(name: 'certification delete'),
                 Permission.find_by(name: 'endorsement create'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'endorsement update'),
                 Permission.find_by(name: 'endorsement delete'),
                 Permission.find_by(name: 'event create'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event update'),
                 Permission.find_by(name: 'event delete'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event signup read'),
                 Permission.find_by(name: 'event signup update'),
                 Permission.find_by(name: 'event signup delete'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'event pilot signup read'),
                 Permission.find_by(name: 'event pilot signup update'),
                 Permission.find_by(name: 'event pilot signup delete'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'feedback update'),
                 Permission.find_by(name: 'feedback delete'),
                 Permission.find_by(name: 'position create'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'position update'),
                 Permission.find_by(name: 'position delete'),
                 Permission.find_by(name: 'user create'),
                 Permission.find_by(name: 'user read'),
                 Permission.find_by(name: 'user update'),
                 Permission.find_by(name: 'user delete'),
             ]

Group.create name: 'facility engineer',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport create'),
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'airport update'),
                 Permission.find_by(name: 'airport delete'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'events coordinator',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'event create'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event update'),
                 Permission.find_by(name: 'event delete'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'feedback update'),
                 Permission.find_by(name: 'feedback delete'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'training administrator',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'certification create'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'certification update'),
                 Permission.find_by(name: 'certification delete'),
                 Permission.find_by(name: 'endorsement create'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'endorsement update'),
                 Permission.find_by(name: 'endorsement delete'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'deputy air traffic manager',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport create'),
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'airport update'),
                 Permission.find_by(name: 'airport delete'),
                 Permission.find_by(name: 'certification create'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'certification update'),
                 Permission.find_by(name: 'certification delete'),
                 Permission.find_by(name: 'endorsement create'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'endorsement update'),
                 Permission.find_by(name: 'endorsement delete'),
                 Permission.find_by(name: 'event create'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event update'),
                 Permission.find_by(name: 'event delete'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event signup read'),
                 Permission.find_by(name: 'event signup update'),
                 Permission.find_by(name: 'event signup delete'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'event pilot signup read'),
                 Permission.find_by(name: 'event pilot signup update'),
                 Permission.find_by(name: 'event pilot signup delete'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'feedback update'),
                 Permission.find_by(name: 'feedback delete'),
                 Permission.find_by(name: 'position create'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'position update'),
                 Permission.find_by(name: 'position delete'),
                 Permission.find_by(name: 'user create'),
                 Permission.find_by(name: 'user read'),
                 Permission.find_by(name: 'user update'),
                 Permission.find_by(name: 'user delete')
             ]

Group.create name: 'air traffic manager',
             atc: true,
             staff: true,
             permissions: [
                 Permission.find_by(name: 'airport create'),
                 Permission.find_by(name: 'airport read'),
                 Permission.find_by(name: 'airport update'),
                 Permission.find_by(name: 'airport delete'),
                 Permission.find_by(name: 'certification create'),
                 Permission.find_by(name: 'certification read'),
                 Permission.find_by(name: 'certification update'),
                 Permission.find_by(name: 'certification delete'),
                 Permission.find_by(name: 'endorsement create'),
                 Permission.find_by(name: 'endorsement read'),
                 Permission.find_by(name: 'endorsement update'),
                 Permission.find_by(name: 'endorsement delete'),
                 Permission.find_by(name: 'event create'),
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event update'),
                 Permission.find_by(name: 'event delete'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event signup read'),
                 Permission.find_by(name: 'event signup update'),
                 Permission.find_by(name: 'event signup delete'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'event pilot signup read'),
                 Permission.find_by(name: 'event pilot signup update'),
                 Permission.find_by(name: 'event pilot signup delete'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'feedback update'),
                 Permission.find_by(name: 'feedback delete'),
                 Permission.find_by(name: 'position create'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'position update'),
                 Permission.find_by(name: 'position delete'),
                 Permission.find_by(name: 'user create'),
                 Permission.find_by(name: 'user read'),
                 Permission.find_by(name: 'user update'),
                 Permission.find_by(name: 'user delete')
             ]
