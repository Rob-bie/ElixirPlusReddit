# EPR - ElixirPlusReddit

EPR is a wrapper for the Reddit API in Elixir. EPR strives to provide simple access to Reddit's API and a flexible
interface.

## Installation

Soon!

## Setting up your first script

*Setting up your script on Reddit*

<img src="http://i.imgur.com/zZyfBMD.png" align="center"></img>

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

Okay, good. Now that we know we're authenticated and ready to make requests, let's ask Reddit about ourselves!

```elixir
iex(5)> Identity.self_data(self(), :me)
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
iex(8)> Identity.self_data(self(), :me)
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
iex(10)> IO.puts("Hey, look at me, I am #{response.name}!")
Hey, look at me, I am elixirplusreddit!
:ok
iex(11)> response = capture.(:me)
"Nope, nothing, nothing at all." # After five very dramatic seconds.
```

The anonymous function `capture` takes a tag and matches it against our mailbox, if it finds something within five seconds 
it grabs it, otherwise we're left with a disappointing message. That's pretty much the gist of it, honestly. If you understand this
you have the proper foundation for making neat stuff. Next we'll take a look at brief overview of EPR's most important bits
and then finally put it to practice and write a (useless) bot!

## A brief, non-comprehensive overview of EPR


He're we'll take a look at some of EPR's different functionality and discuss certain implementation details. If you're following
along I would suggest reconfiguring your iex session before hopping into the next part.

```elixir
iex(12)> IEx.configure(inspect: [limit: 5])
```

We're going to dealing with larger data and this will make it truncate earlier (default is 25) instead of flooding your terminal.

#### Comments and submissions

I think this is the most natural place to begin. No matter what you're writing, you're probably going to have to deal with
gathering comments or submissions from a user or a subreddit. EPR offers a variety of functions for achieving this, so let's
just jump right in and give it a try. Our goal is to gather the last 100 comments posted to /r/Elixir.

```elixir
iex(13)> alias ElixirPlusReddit.API.Subreddit
nil
iex(14)> Subreddit.new_comments(self(), :elixir_comments, :elixir, [limit: 100])
:ok
```

As before, `self()` is where the response is going to be sent, `:elixir_comments` is the tag that'll come with the response.
`:elixir` and `[limit: 100]` are what we're interested. `:elixir` is the name of the subreddit, which can either be an atom or
a string. `[limit: 100]` is our query options. Options differ based on what data you're requesting. The `limit` option specifies
how many items we want from the listing. It's important to note that 25 is the default and is used when the limit you specify is
greater than 100 or less than 0. Options are entirely optional (*ha*) and can be omitted, in this case, as you would expect, the
default values that Reddit's API specifies will be used. Now, let's grab our response and see what's up.

```elixir
iex(15)> response = capture.(:elixir_comments)
%{after: "t1_xxxxxxx", 
  before: nil,
  children: [%{author_flair_css_class: nil, ...}, %{...}, ...],
  modhash: nil}
```

Inside of the `children` field is where all of the comments and their data reside. Each child has many fields but we're interested in
the author of the comment and the comment itself. They are stored in the fields `author` and `body` respectively. Let's check out
who's talking about what!

```elixir
iex(16)> Enum.each(response.children, fn(child) ->
...(16)>   IO.puts("#{child.author}: #{child.body}\n")
...(16)> end)
```

I'm not going to show you the output because it's going to be very large but it's that simple. Now what if we had to gather the `next`
100 comments? One way would be to take our last response's after id from the `after` field and include it in our next request 
as an option with the key `after`. Let's do that.

```elixir
iex(17)> Subreddit.new_comments(self(), :elixir_comments, :elixir, [limit: 100, after: response.after])
:ok
```

What we have acheived here is pagination. In practice, you would never do it this way because EPR has built in pagination
and streaming. I saw no reason to preclude manual pagination and it's nice to know what's happening behind the scenes. Okay, let's
talk about pagination and streaming now. Actually, you should experiment a bit first! Try to get a user's top submissions and print
the upvote count and submission title. Type `h ElixirPlusReddit.API.User.top_submissions` in your shell to get started. Seriously, 
moving on now.

#### Pagination versus streaming


##### Pagination

Often times you'll want to get more than 100 items from a listing. As demonstrated in the previous section, it isn't difficult to
manually pass around the after id but it is not necessary. Let's try paginating through a user's top comments and then talk about
what's happening.

```elixir
iex(18)> {:ok, pid} = User.paginate_top_comments(self(), :comments, :hutsboR) # I'm hutsboR!
{:ok, #PID<x.xx.x>}
```

The first thing you probably noticed is that when we invoke a paginator function a pid is returned with the `:ok` atom. This is
because paginators are implemented as genservers, they chug away at your request in a separate process and send you data as it
becomes available. When there's no more data left to be acquired the genserver will gracefully shutdown and clean itself up. To
see this in action repeatedly call `Process.is_alive?(pid)`.

Another thing you probably noticed is that I didn't specify any options, most notably a limit. Paginators specify a default limit
of 1000, which is also the most items that you can fetch from a listing. Understand that this is not a limit imposed by EPR but
by Reddit. If the resource you're fetching from has less items than the limit, it will give you everything that it has to offer. 
Generous right? Anyways, let's see what's in our mailbox.

```elixir
iex(19)> response = capture.(:comments)
[%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
 %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
 ...]
```

That's a list of the top 100 comments. An important difference in return structure relative to our example in the last section
is that paginators don't bother to return the before and after ids. (and a couple other fields we don't need) It simply returns
what we referred to as `children` before. That's only the first 100 comments though, right? More comments have probably been
delivered to our mailbox by now. Let's just flush them out.

```elixir
iex(20)> flush
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_2c4ka3", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_2ulqbj", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_2whi9u", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_1r6b1t", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_2ug3hx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_1u4hau", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments, :complete}
:ok
```

There's the rest of the comments. Wait, what's that at the bottom? That's actually the interesting bit. When a paginator
is done paginating it sends one last dying message to let us know that is it has completed it's sole duty. This is important
because otherwise there is no convenient, reliable way to tell if we've received all the data that we asked for. Now let's talk 
about streaming, it's actually simpler than paginating but just as useful.

##### Streaming

Soon!
