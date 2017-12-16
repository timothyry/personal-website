require_relative "twitter_miner"

mole = Miner.new()
mole.load("posts.yml")
mole.mine(10)
mole.save("posts.yml")