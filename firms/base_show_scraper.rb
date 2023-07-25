require_relative 'path_helpers.rb'
require 'net/http'
class BaseShowScraper
  include PathHelpers

  attr_reader :firm
  def initialize(firm)
    @firm = firm.downcase
  end

  def download_html
    parsed_index = JSON.parse(File.read(index_parsed_json_file_path))
    parsed_index.each do |result|
      scrape_show_page(result)
    end
  end

  # def file_name(result)
  #   result["full_url"].split("/").last.gsub(".html", "")
  # end

  def scrape_show_page(result)
    file_path = show_scrape_html_file_path(file_name(result))
    if File.exist?(file_path)
      puts "File exists: skipping #{file_path}"
      return
    end
    sleep(0.5)
    url  = result["full_url"]
    begin
      response = fetch_show_url(url)
      if response.code != "200"
        puts "Bad Response: skipping #{url}"
        puts "response code: #{response.code}"
        return
      end

      body = response.body
      write_show_response_to_file(body, result)
    rescue URI::InvalidURIError => e
      puts "skipping #{url}"
      puts "error: #{e}"
    end
  end

  def fetch_show_url(url)
    puts "fetching #{url}"
    url                   = URI(url)
    https                 = Net::HTTP.new(url.host, url.port)
    https.use_ssl         = true
    request               = Net::HTTP::Get.new(url)

    # request               = Net::HTTP::Post.new(url)
    # request["Accept"]     = "application/json"
    # request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
    request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
    response              = https.request(request)

    response
  end

  def include_user_agent_header?
    false
  end

  def show_scrape_html_file_path(name)
    show_scrape_html_folder_path + "/#{name}.html"
  end

  def write_show_response_to_file(body, result)
    file_path = show_scrape_html_file_path(file_name(result))
    puts "writing #{file_path}"
    File.open(file_path, "w") do |f|
      f.write(body)
    end
  end

  def remove_bad_files
    count = 0
    Dir.glob(show_scrape_html_folder_path + "/*.html").each do |file_path|
      doc = Nokogiri::HTML(File.read(file_path))
      if should_remove_file?(doc)
        count += 1
        puts "removing #{file_path}"
        File.delete(file_path)
      end
    end
    puts "removed #{count} files"
  end
end
