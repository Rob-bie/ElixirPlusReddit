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
you have the proper foundation for making neat stuff. Next we'll take a brief tour of EPR's most important bits
and then finally put it to practice and write a (useless) bot!

## A brief, non-comprehensive tour of EPR

Here we'll take a look at some of EPR's different functionality and discuss certain implementation details. If you're following
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

#### Pagination and streaming


##### Pagination

Often times you'll want to get more than 100 items from a listing. As demonstrated in the previous section, it isn't difficult to
manually pass around the after id but it is not necessary. Let's try paginating through a user's top comments and then talk about
what's happening.

```elixir
iex(18)> alias ElixirPlusReddit.API.User
nil
iex(19)> {:ok, pid} = User.paginate_top_comments(self(), :comments, :hutsboR) # I'm hutsboR!
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
iex(20)> response = capture.(:comments)
[%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
 %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
 ...]
```

That's a list of the top 100 comments. An important difference in return structure relative to our example in the last section
is that paginators don't bother to return the before and after ids. (and a couple other fields we don't need) It simply returns
what we referred to as `children` before. That's only the first 100 comments though, right? More comments have probably been
delivered to our mailbox by now. Let's just flush them out.

```elixir
iex(21)> flush
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments,
 [%{user_reports: [], banned_by: nil, link_id: "t3_xxxxxx", ...},
  %{user_reports: [], banned_by: nil, ...}, %{user_reports: [], ...}, %{...},
  ...]}
{:comments, :complete}
:ok
```

There's the rest of the comments. Wait, what's that at the bottom? That's actually the interesting bit. When a paginator
is done paginating it sends one last dying message to let us know that is it has completed it's sole duty. This is important
because otherwise there is no convenient, reliable way to tell if we've received all the data that we've asked for. Now let's talk 
about streaming, a simple but useful feature.

##### Streaming

Unlike pagination, streaming is simply requesting the *same* data indefinitely on an interval. Remember the first example we did in there
introduction section where we got collected a little bit of data about ourselves by calling `Identity.self_data`? The response
structure has a field called `has_mail` which lets us know if we have some form of mail. This includes username mentions, comment and submission replies, messages and so forth. Now what if we write a bot where it's critical to respond to mail and we need to
periodically check for mail? Well let's just take care of that, luckily that's built in.

```elixir
iex(22)> Identity.stream_self_data(self(), :me, 30000)
{:ok, #PID<x.xx.x>}
```

Notice the function name `stream_self_data`, some functions have stream implementations built in and their names
are generally preceded by `stream`. The argument `30000` is how often in milliseconds that the request
should be made. Do we have mail?

```elixir
iex(23)> capture.(:me).has_mail
false
```

Nope, not this time. That's okay, we'll check again (*and again and again and again*) later. Another and probably the most common
use case of streams is checking a subreddit for new comments that need attention. The `Subreddit` and `User`
modules only have two functions for streaming comments and submissions and they fetch data with the `new` sort option. 
In other words, there's no built in support for streaming `hot`, `top` or other sortings. I might add 
built in support in the future but I figured that they have very limited uses unless you're streaming them on a large interval.
As an example, let's say we need to check for new submissions to /r/Elixir.

```elixir
iex(24)> Subreddit.stream_submissions(self(), :elixir_submissions, :elixir, [limit: 10], 1000 * 60 * 10)
{:ok, #PID<x.xx.x>}
```

Now, every 10 minutes we'll get the 10 `newest` submissions. It's important to understand that this doesn't know which submissions
we've seen and as a consequence there is a chance we will see the same submissions. It is the programmer's responsibility to provide
a way to handle duplicate submissions. As a rule of thumb, use a smaller limit and larger interval for relatively inactive subreddits and
users. Pretty simple right? Next we'll take a quick peek at writing custom paginators and streams.

##### Implementing custom paginators and streams

Implementing your own paginators and streams isn't difficult. Let's pretend that we lived in a world where there was no way to
automatically paginate a user's newest comments. We know that `User.new_comments` exists to get a single chunk of a user's comments.
This alone is all we need to expand it into a paginator. Let's do that.

```elixir
iex(25)> Paginator.paginate(self(), :my_comments, {User, :new_comments}, [:hutsboR, [limit: 1000], 0])
{:ok, #PID<x.xx.x>}
```

Let's break down the arguments. We already know that `self()` and `:my_comments` are the pid and tag. The next part is by far
the most interesting bit. The tuple contains two elements, the first being the module name and the second being the function name.
So it reads "The function `new_comments` from the module `User`". This is the resource that we will be paginating from. The next argument
is well, `new_comments`'s arguments. `:hutsboR` is the username, `[limit: 1000]` is the list of options and `0` is.. Well, pretend you didn't
see that. We'll discuss that later. Your paginator will only work if the function you're trying to turn into a paginator returns a `listing`.
The function's return structure must have the `after` and `before` fields. You can always type `h ElixirPlusReddit.API. ...` in your shell
to quickly and conveniently find out. I'm sure I don't need to tell you this but typically this would be wrapped in a function opposed to
manually providing the username and other arguments. In fact, this is exactly how `User.paginate_new_comments` is implemented. Makes sense.
