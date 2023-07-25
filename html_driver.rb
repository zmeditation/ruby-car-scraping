require 'selenium-webdriver'

class HtmlDriver

  def driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')

    # create a new webdriver instance with the options
    driver = Selenium::WebDriver.for :chrome, options: options
  end
end
