# EPR - ElixirPlusReddit

EPR is a wrapper for the Reddit API in Elixir. EPR strives to provide simple access to Reddit's API and a flexible
interface.

## Installation

Soon!

## Setting up your first script

*Setting up your script on Reddit*

<img src="http://i.imgur.com/LPlDoul.png" align="center"></img>

*Configuring your credentials*

Credentials can either be set inside of `config.exs` or be set manually after EPR is started.

```elixir
config :elixirplusreddit, :creds, [
  username:      "username",
  password:      "password",
  client_id:     "[client_id]",
  client_secret: "[secret]"
]

config :elixirplusreddit, user_agent: "something meaningful"
```

or

```elixir
Config.set_credentials("username", 
                       "password", 
                       "[client_id]", 
                       "[secret]", 
                       "something meaningful here")
`````


## A gentle introduction

Now that you've got your script set up, let's talk a little bit about how EPR works so we can start talking to
Reddit! Everytime you make a request it is sent to EPR's request server and stuck inside of a queue. It is issued
and processed at a later time. This is how rate limiting is implemented, requests are issued on an interval that
complies with Reddit's API terms. (*Currently static, hoping to support dymamic ratelimiting in the future*)
All requests, no matter what data you are requesting, expect a pid or name `from` and a tag `tag`. All `from` is,
is who is asking for the data so the request server knows who to send it back to. A tag can be anything and is simply
a way to pattern match on responses when they are received. This may seem cumbersome now but it starts to become
much more intuitive in practice. If you followed the installation instructions and your script is set up,
jump to your project's directory and run `iex -S mix`, if not go read the installation instructions and set up your script!

Before we do anything, I suggest defining a couple of aliases, this is solely for the sake of your fingers and is not mandatory.

```elixir
iex(1)> alias ElixirPlusReddit.TokenServer
nil
iex(2)> alias ElixirPlusReddit.API.Identity
nil
```

When EPR is started a token is automatically acquired for us and a new one is acquired automatically when necessary, 
this can easily be verified. *NOTE: This assumes that credentials were set inside of config.exs, if they were set manually
call* `TokenServer.acquire_token` *first. All subsequent tokens will be acquired automatically.*

```elixir
iex(4)> TokenServer.token
"bearer xxxxxxxx-xxxxxxxxxxxxxxxxxxx_xxxxxxx"
```

Okay, good. Now that we know we're authenticated and ready to make request, let's ask Reddit about ourselves!

```elixir
iex(5)> Identity.self_data(self, :me)
:ok
```

I'm sure most people who are reading this already know that `self` is just the current process's pid, `:me` is
the value that is going to accompany our response. Hey, these are actually the `from` and `tag` parameters that
I mentioned earlier. So if you're wondering where the hell our response is, assuming that the message didn't
take a wrong turn and an ample amount of time has passed, it's in our mailbox. Let's flush it out!

```elixir
iex(6)> flush
{:me,
 %{comment_karma: 8, 
   created: 1453238732.0,
   created_utc: 1453209932.0,
   gold_creddits: 0, 
   gold_expiration: nil, 
   has_mail: false, 
   has_mod_mail: false
   has_verified_email: true, 
   hide_from_robots: false, 
   id: "txy38",
   inbox_count: 0, 
   is_gold: false, 
   is_mod: false, 
   is_suspended: false,
   link_karma: 14, 
   name: "elixirplusreddit", 
   over_18: false,
   suspension_expiration_utc: nil}}
```

Oh look, that's me. As you can see, all keys are stored as atoms, this allows them to be accessed with the dot syntax. Once again, 
you probably already knew that but I'll show you that later anyways. Right now we have a bigger problem! This isn't particularly 
useful if there's no way to grab the information out of our mailbox. You know... So we can do stuff with it? Let's write a 
little utility function to do exactly that and try again.

```elixir
iex(7)> capture = fn(tag) ->
...(7)>   receive do
...(7)>     {^tag, response} -> response
...(7)>   after
...(7)>     5000 -> "Nope, nothing, nothing at all."
...(7)>   end
...(7)> end
#Function<x.xxxxxxxx/1 in :erl_eval.expr/5>
iex(8)> Identity.self_data(self, :me)
:ok
iex(9)> response = capture.(:me)
%{comment_karma: 9, 
  created: 1453238732.0, 
  created_utc: 1453209932.0,
  gold_creddits: 0, 
  gold_expiration: nil, 
  has_mail: false, 
  has_mod_mail: false,
  has_verified_email: true, 
  hide_from_robots: false, 
  id: "txy38",
  inbox_count: 0, 
  is_gold: false, 
  is_mod: false, 
  is_suspended: false,
  link_karma: 14, 
  name: "elixirplusreddit", 
  over_18: false,
  suspension_expiration_utc: nil}
iex(10)> IO.puts("Hey, look at me, I'm #{response.name}!")
Hey, look at me, I'm elixirplusreddit!
:ok
iex(11)> response = capture.(:me)
"Nope, nothing, nothing at all." # After five very dramatic seconds.
```

The anonymous function `capture` takes a tag and matches it against our mailbox, if it finds something within five seconds 
it grabs it, otherwise we're left with a disappointing message. That's pretty much the gist of it, honestly. If you understand this
you have the proper foundation for making neat stuff. Next we'll cover an overview (non-comprehensive) of EPR and then finally we'll 
write a (useless) bot!
