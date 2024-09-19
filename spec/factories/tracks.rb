# frozen_string_literal: true

# == Schema Information
#
# Table name: tracks
#
#  id                :bigint           not null, primary key
#  artist            :string
#  length_in_seconds :integer
#  order_number      :integer
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :track do
    title { 'Song' }
    order_number { 1 }
    length_in_seconds { 2 }
  end
end
