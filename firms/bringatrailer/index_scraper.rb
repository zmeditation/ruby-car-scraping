require_relative '../base_index_scraper.rb'
class BringatrailerIndexScraper < BaseIndexScraper

  BASE_URL = 'https://bringatrailer.com/race-car/'
  CSS_SELECTOR = ".auctions-completed-container a.listing-card"
  NAV_SELECTOR = ".auctions-completed-container .button-show-more"
  TIMEOUT = 200

  def initialize
    super("bringatrailer")
  end

  def navigate_page
    driver.navigate.to BASE_URL
    wait_for_elements(CSS_SELECTOR)
  end

  def wait_for_elements(css_selector)
    timeout = TIMEOUT
    while driver.find_elements(:css, css_selector).length == 0
      sleep 1
      timeout -= 1
      break if timeout < 1
    end
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)
    rows = doc.css(CSS_SELECTOR)

    rows.map do |row|
      create_row_hash(row)
    rescue => e
      {}
    end
  end

  def create_row_hash(row)
    full_url    = row["href"]
    {
      "Auction URL": full_url,
    }
  end

  def scrape_html
    clear_index_files
    navigate_and_parse

    driver.quit
    write_parsed_file
  end

  def navigate_and_parse
    navigate_page
    return if driver.find_elements(:css, CSS_SELECTOR).length == 0

    json = []

    loop do
      puts "Looping through page 0"
      
      if driver.find_elements(:css, NAV_SELECTOR).length == 0
        json = parse_page(driver.page_source)
        break
      end

      element = driver.find_element(:css, NAV_SELECTOR)
      driver.execute_script("arguments[0].click();", element)

      wait_for_elements(CSS_SELECTOR)
    end

    write_response_to_file(json, 0)
  end

end