# frozen_string_literal: true

FactoryGirl.define do
  factory :permission do
    sequence(:name) { |n| "Permission #{n}" }
  end
end
