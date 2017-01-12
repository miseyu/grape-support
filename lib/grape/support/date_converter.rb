# == 日付変換
# 対象の期間を月、週、日に分ける
#
#
# Author: Yuji Mise
# Copyright 2014  
#
module Grape
  module Support
    module DateConverter
      extend ActiveSupport::Concern

      included do

        def convert_date_range(started_at, ended_at)
          dates = (started_at.to_date..ended_at.to_date).to_a
          date_box = { daily: {}, weekly: Hash.new { |hash, key| hash[key] = [] }, monthly: Hash.new { |hash, key| hash[key] = [] } }

          dates.each do |date|
            target_at = date.to_time.beginning_of_day
            date_box[:daily][target_at] = target_at
            date_box[:weekly][target_at.all_week(:sunday).first.beginning_of_day] << target_at
            date_box[:monthly][target_at.beginning_of_month.beginning_of_day] << target_at
          end

          result = Hashie::Mash.new daily: [], weekly: [], monthly: []
          date_box[:monthly].each do |key, value|
            if value.first == key && value.last == key.end_of_month.beginning_of_day
              result.monthly << key
              value.each do |month_date|
                date_box[:weekly].delete month_date.all_week(:sunday).first
                date_box[:daily].delete month_date
              end
            end
          end

          date_box[:weekly].each do |key, value|
            if value.first == key && value.last == key.all_week(:sunday).last.beginning_of_day
              result.weekly << key
              value.each do |week_date|
                date_box[:daily].delete week_date
              end
            end
          end

          result.daily = date_box[:daily].values
          result
        end

      end
    end
  end
end
