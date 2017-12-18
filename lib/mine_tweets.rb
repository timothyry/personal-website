require_relative "twitter_miner"

mole = Miner.new()
mole.load("posts.yml")
mole.connect
mole.mine()
mole.save("posts.yml")