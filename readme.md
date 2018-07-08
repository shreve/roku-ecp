Roku External Control Protocol
==============================

This library is a client for the Roku ECP, which allows you to control Roku
devices on your local network via http.

`Roku::Discover` allows you to find a Roku device on your network.

`Roku::Client` allows you to interact with Roku devices.

`Roku::Input` is a small terminal application that provides keyboard shortcuts
for interacting.


## Usage

Find your Roku device and automatically configure the client to use it.

```ruby
Roku::Client.find_device!
# => "http://192.168.0.106:8060/"
```

Begin interacting

```ruby
Roku::Client.active_app
# => #<Struct:Roku::App:0x5611ec31c2a8
#      id = "13535"
#      name = "Plex"
#      type = "appl"
#      version = "5.3.4"

Roku::Client.keypress(:Play)
# => true
```

View lib/roku/client.rb for complete list of buttons presses.

## Limitations / TODO

This approach only supports one device at a time. I only have one device, so I
can't test a scenario where multiple devices can be found on the network.
