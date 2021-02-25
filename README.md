# Umbrtonic

[![build](https://github.com/umbrellio/umbrtonic/workflows/build/badge.svg)](https://github.com/umbrellio/umbrtonic/actions)

Gem for transferring Active Support Instrumentation events 
to the InfluxDB database via UDP without boilerplate code.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'umbrtonic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install umbrtonic


## Configuration
Under the hood Umbrtonic uses [Qonfig](https://github.com/0exp/qonfig) gem.

By default, gem sends data to 127.0.0.1:8089. You are able to change this easily:

```ruby
Umbrtonic.configure do |conf|
  conf.influxdb.host = "another.machine"
  conf.influxdb.port = 4444
end
```


### Using a custom prefix
Optionally you are able to set a prefix:

```ruby
Umbrtonic.configure do |conf|
  conf.prefix = "my_app"
end
```

For example, when you subscribe to `actions`, 
points to InfluxDB will be sent as `my_app_actions`.

Alternatively, it is possible to configure with file:

```yaml
production:
  prefix: custom
  influxdb:
    host: 127.0.0.1
    port: 8094
# etc
```

and then load configuration:

```ruby
Umbrtonic.config.load_from_yaml(
  Rails.root / "config" / "umbrtonic.yml",
  expose: Rails.env
)
```

## Usage
```ruby
Umbrtonic.bind("process_action.action_controller") do |inf, event, payload|
  inf.values(
    count:      1, 
    duration:   event.duration, 
    db_runtime: event.payload[:db_runtime],
  )
  
  inf.tags(
    controller: payload[:controller], 
    action:     payload[:action],
  )
end
```

Gem provides instance of InfluxDB data builder
and information about the event and payload for quick access:

```ruby
Umbrtonic.bind("process_action.action_controller") do |inf, event, payload|
  event.name     # => "process_action.action_controller"
  event.duration # => 10 (in milliseconds)
  event.payload  # => event-specific payload 

  payload        # => event-specific payload, alias for event.payload 
end
```



See more information about Active Support Notifications 
[here](https://guides.rubyonrails.org/active_support_instrumentation.html)

You are able to set custom name for event:

```ruby
Umbrtonic.bind("process_action.action_controller", measurement: "actions") do |inf, event, payload|
  # your bindings
end
```

In this example events will be sent as `actions`.

There is complete list of 
[Ruby on Rails hooks](https://guides.rubyonrails.org/v5.1/active_support_instrumentation.html#rails-framework-hooks)


## Contributing

Bug reports and pull requests are welcome on GitHub 
at https://github.com/umbrellio/umbrtonic.
