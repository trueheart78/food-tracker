# frozen_string_literal: true

module Support
  module Time
    def static_time
      ::Time.local 2029, 3, 23
    end

    def today
      days_ago 0
    end

    def tomorrow
      days_from_now 1
    end

    def a_week_from_now
      days_from_now 7
    end

    def two_days_from_now
      days_from_now 2
    end

    def three_days_from_now
      days_from_now 3
    end

    def four_days_from_now
      days_from_now 4
    end

    def five_days_from_now
      days_from_now 5
    end

    def six_days_from_now
      days_from_now 6
    end

    def yesterday
      days_ago 1
    end

    def two_days_ago
      days_ago 2
    end

    def three_days_ago
      days_ago 3
    end

    def four_days_ago
      days_ago 4
    end

    def a_week_ago
      days_ago 7
    end

    def days_from_now(days)
      days_ago(-days)
    end

    def days_ago(days)
      (static_time - (days * one_day)).strftime time_format
    end

    def time_format
      '%m/%d/%y'
    end

    def one_day
      60 * 60 * 24
    end
  end
end
