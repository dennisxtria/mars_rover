# MarsRover

This is a `MarsRover` implementation in Elixir.

## Let's get started

To start with, the first thing that you need to do is clone the repo from GitHub.

Let's navigate into a directory that you want the application in. Cloning the repo will create a new directory called `mars_rover` wherever we run the clone command. Here's how:

```bash
git clone https://github.com/dennisxtria/mars_rover.git
```

Then, `cd` into the `mars_rover` directory.

```bash
cd mars_rover
```

With that out of the way, getting the required dependencies can be achieved 
running in the command line the following:

```bash
mix deps.get
```

The application can be run with:

```bash
iex -S mix
```

Once being in IEx, you can check the application by running

```elixir
Interactive Elixir (1.11.2) - press Ctrl+C to exit (type h() ENTER for help)
iex> MarsRover.start()
```

