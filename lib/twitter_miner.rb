require 'yaml'
require "twitter"

class Miner

  attr_accessor :client

  def initialize
    @posts = []
    output("Miner connecting to Twitter ...\n")
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'Ax2NVLgGifTUPqqhDF6eHUsfS'
      config.consumer_secret = 'Oi7VLrBhi8hFQ4ByJfaao8p6pi6xBiN4w1nvGu2L4smTWVPATe'
    end
    output("Success.\n")
  end
  
  def output(out_text)
    puts "#{Time.now.to_s}: #{out_text}"
  end
  
  def load(file)
    @posts = begin
      YAML.load(File.open("#{file}"))
    rescue ArgumentError => e
      output "Could not parse YAML: #{e.message}"
    rescue Errno::ENOENT => en
      output "Could not find YAML file. Continuing."
    end
    output "Posts loaded from #{file}"
  end

  def save(file)
    File.open("#{file}", "w") {|file| file.write(@posts.to_yaml) }
    output "Posts saved to #{file}."
  end
  
  def pop
    output "Sampling from posts..."
    post = @posts.sample
    @posts -= [post]
    return post
  end
  
  def mine(amount)
    new_posts = []
    if amount < 0
      output("Amount of tweets to mine must be > 0.")
    elsif
      amount > 40
      output("Amount of tweets to mine cannot exceed 40.")
    else
      output("Preparing to mine [#{amount}] tweets.")
      maxAttempts = [3, (amount.to_f*0.25).to_i].max
      amount.times do |current|
        begin
          attempts ||= 1
          output("Mining tweet #{current+1} of #{amount}. (Attempt #{attempts} of #{maxAttempts})")
          new_post = Blerb.new(@client)
          new_posts << new_post
        rescue Twitter::Error => te
          if attempts <= maxAttempts
            output "Error: Time-out. Sleeping #{5**attempts} seconds before re-attempting mine."
            sleep(5**attempts)
            attempts += 1
            retry
          else
            output "Error: Exceeded timeout attempts."
          end
        end
      end
      if !new_posts.nil? && !@posts.nil?
        new_posts.each do |curr_new_post|
          @posts.each do |curr_master_post|
            new_posts -= [curr_new_post] if curr_new_post.dump[3].to_s == curr_master_post[3].to_s
          end
        end
      end
      @posts = [] if @posts.nil?
      output("Complete. Mined #{new_posts.size} unique tweets.")
      new_posts.each {|new_post| @posts << new_post.dump}
    end
  end
end

class Blerb
  
  def initialize(client)
    @client = client
    @me = "@tr_codes"
    print "#{Time.now.to_s}: Mining tweet from #{@me}"
    @tweeter = @client.user(@me)
    @tweet = client.user_timeline(@tweeter, {:count => 100, :exclude_replies => true}).sample
    @tweet_body = @tweet.full_text.dup.force_encoding("utf-8")
  end

  
  def dump 
    [@me, @tweeter.profile_image_uri.to_s, @tweet_body]
  end
end