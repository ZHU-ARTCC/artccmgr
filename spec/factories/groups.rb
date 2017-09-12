FactoryGirl.define do
  factory :group do
    sequence(:name){|i| "group #{i}"}

    trait :controllers do
      artcc_controllers true
    end

    trait :perm_feedback_create do
      permissions { Permission.where(name: 'feedback create') }
    end

    trait :perm_feedback_delete do
      permissions { Permission.where(name: 'feedback delete') }
    end

    trait :perm_feedback_read do
      permissions { Permission.where(name: 'feedback read') }
    end

    trait :perm_feedback_read_published do
      permissions { Permission.where(name: 'feedback read published') }
    end

    trait :perm_feedback_update do
      permissions { Permission.where(name: 'feedback update') }
    end
  end
end
