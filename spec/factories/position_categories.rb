# frozen_string_literal: true

FactoryGirl.define do
  factory :position_category, class: 'Position::Category' do
    sequence(:name)  { |n| "Category #{n}" }
    sequence(:short) { |s| "CAT#{s}" }
  end
end
