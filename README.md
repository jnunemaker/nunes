# nunes

The friendly gem that instruments everything for you, like I would if I could.

## Why "nunes"?

Because I don't work for you, but even that could not stop me from trying to make it as easy as possible for you to instrument ALL THE THINGS.

## Installation

Add this line to your application's Gemfile:

    gem "nunes"

Or install it yourself as:

    $ gem install nunes

## Compatibility

* >= Ruby 1.9
* Rails 4.2.x

Note: you can use v0.3.1 is for rails 3.2.x support.

## Usage

nunes works out of the box with [instrumental app](http://instrumentalapp.com) (my personal favorite) and [statsd](https://github.com/reinh/statsd). All you need to do is subscribe using an instance of statsd or instrumental's agent and you are good to go.

### With Instrumental

```ruby
require "nunes"
I = Instrument::Agent.new(...)
Nunes.subscribe(I)
```

### With Statsd

```ruby
require "nunes"
statsd = Statsd.new(...)
Nunes.subscribe(statsd)
```

### With Some Other Service

If you would like for nunes to work with some other service, you can easily make an adapter. Check out the [existing adapters](https://github.com/jnunemaker/nunes/tree/master/lib/nunes/adapters) for examples. The key is to inherit from `Nunes::Adapter` and then convert the `increment` and `timing` methods to whatever the service requires.

## What Can I Do For You?

If you are using nunes with Rails, I will subscribe to the following events:

* `process_action.action_controller`
* `render_template.action_view`
* `render_partial.action_view`
* `deliver.action_mailer`
* `receive.action_mailer`
* `sql.active_record`
* `cache_read.active_support`
* `cache_generate.active_support`
* `cache_fetch_hit.active_support`
* `cache_write.active_support`
* `cache_delete.active_support`
* `cache_exist?.active_support`

Whoa! You would do all that for me? Yep, I would. Because I care. Deeply.

Based on those events, you'll get metrics like this in instrumental and statsd:

#### Counters

* `action_controller.status.200`
* `action_controller.format.html`
* `action_controller.controller.Admin.PostsController.new.status.403`
* `action_controller.controller.Admin.PostsController.index.format.json`
* `active_support.cache.hit`
* `active_support.cache.miss`

#### Timers

* `action_controller.runtime.total`
* `action_controller.runtime.view`
* `action_controller.runtime.db`
* `action_controller.controller.PostsController.index.runtime.total`
* `action_controller.controller.PostsController.index.runtime.view`
* `action_controller.controller.PostsController.index.runtime.db`
* `action_controller.controller.PostsController.index.status.200`
* `action_controller.controller.PostsController.index.format.html`
* `action_view.template.app.views.posts.index.html.erb` - where `app.views.posts.index.html.erb` is the path of the view file
* `action_view.partial.app.views.posts._post.html.erb` - I can even do partials! woot woot!
* `action_mailer.deliver.PostMailer`
* `action_mailer.receive.PostMailer`
* `active_record.sql`
* `active_record.sql.select`
* `active_record.sql.insert`
* `active_record.sql.update`
* `active_record.sql.delete`
* `active_support.cache.read`
* `active_support.cache.fetch`
* `active_support.cache.fetch_hit`
* `active_support.cache.fetch_generate`
* `active_support.cache.write`
* `active_support.cache.delete`
* `active_support.cache.exist`

### But wait, there's more!!!

In addition to doing all that automagical work for you, I also allow you to wrap your own code with instrumentation. I know, I know, sounds too good to be true.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save
end
```

This will instrument the timing of the User instance method save. What that means is when you do this:

```ruby
user = User.new(name: 'NUNES!')
user.save
```

An event named `instrument_method_time.nunes` will be generated, which in turn is subscribed to and sent to whatever you used to send instrumentation to (statsd, instrumental, etc.). The metric name will default to class.method. For the example above, the metric name would be `User.save`. No fear, you can customize this.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, 'crazy_town.save'
end
```

Passing a string as the second argument sets the name of the metric. You can also customize the name using a Hash as the second argument.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, name: 'crazy_town.save'
end
```

In addition to name, you can also pass a payload that will get sent along with the generated event.

```ruby
class User < ActiveRecord::Base
  extend Nunes::Instrumentable

  # wrap save and instrument the timing of it
  instrument_method_time :save, payload: {pay: "loading"}
end
```

If you subscribe to the event on your own, say to log some things, you'll get a key named `:pay` with a value of `"loading"` in the event's payload. Pretty neat, eh?

## `script/bootstrap`

This script will get all the dependencies ready so you can start hacking on nunes.

```
# to learn more about script/bootstrap
script/bootstrap help
```

## `script/test`

For your convenience, there is a script to run the tests. It will also perform `script/bootstrap`, which bundles and all that jazz.

```
# to learn more about script test
script/test help
```

## `script/watch`

If you are like me, you are too lazy to continually run `script/test`. For this scenario, I have included `script/watch`, which will run `script/test` automatically anytime a relevant file changes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
