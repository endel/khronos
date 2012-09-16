khronos [![Build Status](https://secure.travis-ci.org/endel/khronos.png)](http://travis-ci.org/endel/khronos)
===

Simple HTTP-based Job scheduling for the cloud.

Features
---

  - Schedule of HTTP Requests
  - Configure recurrency per request
  - Log HTTP status code for every request made
  - Query the database via REST API
  - Postgresql, MySQL and SQLite supported. (mongodb will be supported soon)

How it works
---

Khronos use a rack app to schedule and query for scheduled tasks, and a worker
process to execute them in the background.

At 'examples' directory you find two rackup files for these processes.

How to use
---

Create a scheduled task:

    RestClient.post('http://localhost:3000/task', {
      :context => 'test',
      :at => 24.hours.from_now,
      :task_url => "http://myapp.com/do-something-awesome",
      :recurrency => 12.hours
    })
    # => "{\"active\":true,\"at\":\"2012-09-15T21:24:56-03:00\",\"context\":\"test\",\"id\":1,\"recurrency\":1,\"task_url\":\"http://myapp.com/do-something-awesome\"}"

Query for a scheduled task:

    RestClient.get('http://localhost:3000/task', :params => { :context => 'test' })
    # => "{\"active\":true,\"at\":\"2012-09-15T21:24:56-03:00\",\"context\":\"test\",\"id\":1,\"recurrency\":1,\"task_url\":\"http://myapp.com/do-something-awesome\"}"

Delete a scheduled task by query:

    RestClient.delete('http://localhost:3000/task', :params => { :status_code => 404 })
    # => "{\"deleted\":3}"
    RestClient.delete('http://localhost:3000/task', :params => { :id => 9 })
    # => "{\"deleted\":1}"

Query for logs for tasks that already ran.

    RestClient.get('http://localhost:3000/schedule/logs', :params => { :status_code => 500 })
    # => "[{\"id\":3,\"schedule_id\":1,\"started_at\":\"2012-09-15T13:38:48-03:00\",\"status_code\":500},{\"id\":5,\"schedule_id\":2,\"started_at\":\"2012-09-15T13:38:48-03:00\",\"status_code\":500}]"

Note: these examples are using [rest-client](https://github.com/archiloque/rest-client/) and [activesupport](https://github.com/rails/rails/tree/master/activesupport).

Contributing
---

Feel free to fork and send pull requests with features and/or bug fixes.

License
---

Khronos is released under the MIT license. Please read the LICENSE file.
