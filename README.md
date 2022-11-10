# Nodeviz

POC for visualizing erlang nodes and processes, inspired by [Visualixir](https://github.com/koudelka/visualixir)

# Running it

Try out visualizing multiple nodes:

1. From one terminal, run `PORT=4001 iex --sname nodeviz1 --cookie foo -S mix phx.server`

2. From another terminal run `PORT=4002 iex --sname nodeviz2 --cookie foo -S mix phx.server`

3. Visit `localhost:4001`

4. From the iex session of `nodeviz1`:

```
iex(nodeviz1@<your computer>)8> Node.connect(:"nodeviz2@<your computer>")
```

You should see a node appear in the force graph.
