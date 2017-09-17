FactoryGirl.define do
  factory :group do
    sequence(:name){|i| "group #{i}"}

    trait :artcc_controllers do
      artcc_controllers true
    end

    trait :visiting_controllers do
      visiting_controllers true
    end

    trait :perm_event_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'event create')
      end
    end

    trait :perm_event_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'event delete')
      end
    end

    trait :perm_event_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'event read')
      end
    end

    trait :perm_event_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'event update')
      end
    end

    trait :perm_event_signup_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'event signup create')
      end
    end

    trait :perm_event_signup_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'event signup delete')
      end
    end

    trait :perm_event_signup_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'event signup read')
      end
    end

    trait :perm_event_signup_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'event signup update')
      end
    end

    trait :perm_event_pilot_signup_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'event pilot signup create')
      end
    end

    trait :perm_event_pilot_signup_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'event pilot signup delete')
      end
    end

    trait :perm_event_pilot_signup_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'event pilot signup read')
      end
    end

    trait :perm_event_pilot_signup_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'event pilot signup update')
      end
    end

    trait :perm_feedback_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'feedback create')
      end
    end

    trait :perm_feedback_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'feedback delete')
      end
    end

    trait :perm_feedback_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'feedback read')
      end
    end

    trait :perm_feedback_read_published do
      after :build do |g|
        g.permissions << Permission.where(name: 'feedback read published')
      end
    end

    trait :perm_feedback_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'feedback update')
      end
    end

    trait :perm_position_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'position create')
      end
    end

    trait :perm_position_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'position delete')
      end
    end

    trait :perm_position_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'position read')
      end
    end

    trait :perm_position_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'position update')
      end
    end

    trait :perm_user_create do
      after :build do |g|
        g.permissions << Permission.where(name: 'user create')
      end
    end

    trait :perm_user_delete do
      after :build do |g|
        g.permissions << Permission.where(name: 'user delete')
      end
    end

    trait :perm_user_read do
      after :build do |g|
        g.permissions << Permission.where(name: 'user read')
      end
    end

    trait :perm_user_update do
      after :build do |g|
        g.permissions << Permission.where(name: 'user update')
      end
    end
  end
end
