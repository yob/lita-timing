# lita-timing

A small collection of utility classes that make it easier to work with time, recurring
events and rate limits in lita.

## Installation

Add this gem to your lita installation by including the following line in your Gemfile:

    gem "lita-timing"

## Usage

This gem is not a lita handler or plugin in its own right, but it is easily used
by other lita plugins.

### Rate Limits

lita comes with an "every" helper that executes a block of code at fixed
intervals. However the interval is only stored in memory, which means
long intervals will often be reset if the lita process restarts (like
during a deploy).

For handlers that want to execute code at fixed intervals, the RateLimit
class can be used in conjunction with the built in every() helper:

    one_minute = 60
    one_week = 60 + 60 + 24 + 7
    every(one_minute) do
      RateLimit.new("interval-name", redis).once_every(one_week) do
        # weekly code in here
      end
    end

### Scheduled Timing

If you have code that should execute at a fixed time each day or week, Lita::Timing::Scheduled
can be used in conjunction with the built-in every() helper.

For daily execution:

    one_minute = 60
    every(one_minute) do
      Lita::Timing::Scheduled.new("interval-name", redis).daily_at("11:00") do
        # daily code in here
      end
    end

For daily execution on certain days:

    one_minute = 60
    every(one_minute) do
      Lita::Timing::Scheduled.new("interval-name", redis).daily_at("11:00", [:monday, :tuesday]) do
        # daily code in here
      end
    end

For weekly execution:

    one_minute = 60
    every(one_minute) do
      Lita::Timing::Scheduled.new("interval-name", redis).weekly_at("11:00", :friday) do
        # weekly code in here
      end
    end

All times should be specified in UTC.

### Sliding Windows

Sometimes a handler wants to periodically execute a block of code with a start
and end time, and ensure that every minute of the day is handled by one of the
executions. The text-book use case is polling an external API for updates within
a time range.

The SlidingWindow class can help. For best results, use it in conjunction with the 
built in every() helper.

Redis is used to persist the end of the last window that executed and ensure the
block doesn't execute again until that window is passed.

    window = SlidingWindow.new("my-sliding-window", redis)
    every(one_minute) do
      window.advance(duration_minutes: 30) do |window_start, window_end|
        puts "#{window_start} -> #{window_end}"
      end
    end

Call this as often as you like, and the block passed to advance() will
only execute if it's been 30 minutes since the last time it executed.

## TODO

* Add timezone support to Scheduled

