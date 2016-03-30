require "pry"
require "pg"
require_relative "../../server"
require "pry"

class Article
  attr_reader :info
  attr_accessor :errors

  def initialize(info = {})
    @info = info
    @errors = []
  end

  def self.all
    @object_array = []
    article_list = db_connection { |conn| conn.exec("SELECT * FROM articles")}
      article_list.each do |info|
        @object_array << Article.new(info)
      end
      @object_array
  end

  def title
    @info["title"]
  end

  def url
    @info["url"]
  end

  def description
    @info["description"]
  end

  def empty_val?
    if title.empty? || url.empty? || description.empty?
      @errors << "Please completely fill out form"
    end
  end

  def url_empty?
    if !url.empty? && !url.include?("https://")
      @errors << "Invalid URL"
    end
  end

  def repeat?
    x = 0
    Article.all.each do |thing|
      if url == thing.info["url"]
        x = 1
      end
    end
    if x == 1
      @errors << "Article with same url already submitted"
    end
  end

  def description?
    if !description.empty? && description.size < 20
      @errors << "Description must be at least 20 characters long"
    end
  end

  def valid?
    empty_val?
    url_empty?
    repeat?
    description?
    if @errors.empty?
      true
    else
      false
    end
  end

  def save
    if valid?
      db_connection do |conn|
        conn.exec_params("INSERT INTO articles (title, url, description)
      VALUES ($1, $2, $3);",
      [title, url, description])
    end
      true
    else
      false
    end
  end
end
