v0.3.0 (XXX)
* Added support for excuting blocks are a scheduled daily or weekly time
* Add mutexes to ensure code that executes via this gem never runs concurrently

v0.2.0 (19th June 2016)
* Ensure unused RateLimit data eventually expires from redis
* Ensure SlidingWindow never returns overlapping time periods

v0.1.0 (15th June 2016)
* initial release
