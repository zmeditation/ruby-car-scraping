require_relative 'path_helpers.rb'
class BaseIndexScraper
  include PathHelpers
  attr_reader :firm

  def initialize(firm)
    @firm   = firm.downcase
  end

  def driver
    @driver ||= HtmlDriver.new.driver
  end

  def write_response_to_file(json, page)
    puts "Writing page #{page} to file #{index_scrape_json_file_path}"
    file_json = if File.exist?(index_scrape_json_file_path) && File.size(index_scrape_json_file_path) > 0
      JSON.parse(File.read(index_scrape_json_file_path))
    else
      []
    end

    file_json << { page: page, json: json }
    File.open(index_scrape_json_file_path, "w") do |f|
      f.write(JSON.pretty_generate(file_json))
    end
  end

  def write_parsed_file
    parsed_index = JSON.parse(File.read(index_scrape_json_file_path))
    # remove empty json
    res          = parsed_index.map { |k| k['json']}.flatten.reject { |k| k.empty? }
    # remove duplicates by Auction URL
    res          = res.uniq { |k| k['Auction URL'] }

    File.open(index_parsed_json_file_path, "w") do |f|
      f.write(JSON.pretty_generate(res))
    end
  end

  def clear_index_files
    puts "Clearing index files"
    File.delete(index_scrape_json_file_path) if File.exist?(index_scrape_json_file_path)
    File.delete(index_parsed_json_file_path) if File.exist?(index_parsed_json_file_path)
  end

  def scrape_sitemap
    clear_index_files

    scraper = BaseShowScraper.new(firm)
    response = scraper.fetch_show_url(attorney_sitemap_url)

    doc = Nokogiri::XML(response.body)

    json = doc.css(css_selector).map do |e|
      {
        "full_url": e.text.strip
      }
    end

    write_response_to_file(json, 'sitemap')
    write_parsed_file
  end
end
