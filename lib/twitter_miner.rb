require 'yaml'
require "twitter"

class Miner

  attr_accessor :client

  def initialize
    @posts = []
    @connected = false
    output "New miner started up. Not currently connected to twitter."
  end
  
  def connect
    output("Miner connecting to Twitter ...\n")
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'Ax2NVLgGifTUPqqhDF6eHUsfS'
      config.consumer_secret = 'Oi7VLrBhi8hFQ4ByJfaao8p6pi6xBiN4w1nvGu2L4smTWVPATe'
    end
    output("Success.\n")
    @connected = true
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
    if @posts.nil?
      @posts = []
      output "No previous tweets found in storage."
    else
      output "Posts loaded from #{file}"
    end
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
  
  def mine()
    if @connected
      new_posts = []
      maxAttempts = 3;
      begin
        attempts ||= 1
        @new_posts = Blerbs.new(@client).dump
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
      @posts = !@posts.nil? ? (@posts + @new_posts).uniq : @new_posts.uniq
      puts @posts
    else
      output("Error: Not connected to twitter. Connect first.")
    end
  end
end

class Blerbs
  
  def initialize(client)
    @client = client
    @me = "@tr_codes"
    @tweeter = @client.user(@me)
    @tweets = @client.user_timeline(@tweeter, {:count => 100, :exclude_replies => true, :exclude_retweets => true, :tweet_mode => 'extended'})
  end

  
  def dump 
    tweets = []
    @tweets.each do |tweet|
      puts "#{tweet.attrs} \n\n"
      if tweet.attrs[:retweeted_status].nil?
        tweet_body = tweet.attrs[:full_text].force_encoding('utf-8')
      else
        origTweeter = tweet.attrs[:entities][:user_mentions].first[:user_name].to_s
        tweet_body = "RT @#{origTweeter} #{tweet.attrs[:retweeted_status][:full_text].force_encoding('utf-8')}"
      end
        tweets.push [@me, @tweeter.profile_image_uri.to_s, tweet_body, tweet.created_at]
    end
  tweets
  end
end