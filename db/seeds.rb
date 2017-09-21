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
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'guest',
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'visiting controller',
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'controller',
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'mentor',
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'instructor',
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'webmaster',
             artcc_controllers: true,
             permissions: [
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
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read published'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'events coordinator',
             artcc_controllers: true,
             permissions: [
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
             artcc_controllers: true,
             permissions: [
                 Permission.find_by(name: 'event read'),
                 Permission.find_by(name: 'event signup create'),
                 Permission.find_by(name: 'event pilot signup create'),
                 Permission.find_by(name: 'feedback read'),
                 Permission.find_by(name: 'position read'),
                 Permission.find_by(name: 'user read')
             ]

Group.create name: 'deputy air traffic manager',
             artcc_controllers: true,
             permissions: [
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
             artcc_controllers: true,
             permissions: [
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
