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
require 'rails_helper'

RSpec.describe Track do
  it 'has the correct non-string column types' do
    columns = ActiveRecord::Base.connection.columns(:tracks)

    expect(columns.find { |c| c.name == 'order_number' }.sql_type).to eq 'integer'
    expect(columns.find { |c| c.name == 'length_in_seconds' }.sql_type).to eq 'integer'
  end

  it 'has seeds' do
    load Rails.root.join('db/seeds.rb').to_s

    expect(described_class.count).to eq 5
    expect(described_class.order(:title).pluck(:title, :order_number, :artist, :length_in_seconds))
      .to eq [['I Wanna Dance with Somebody (Who Loves Me)', 1, 'Whitney Houston', 314],
              ["Sweet Child O' Mine", 2, "Guns N' Roses", 302],
              ['Take On Me', 5, 'a-ha', 229],
              ['Total Eclipse of the Heart', 3, 'Bonnie Tyler', 267],
              ['When Doves Cry', 4, 'Prince', 352]]
  end
end
