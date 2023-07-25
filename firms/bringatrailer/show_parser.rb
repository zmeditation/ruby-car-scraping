require_relative 'show_scraper'
class BringatrailerShowParser < BaseShowParser
    def initialize
      super("bringatrailer")
    end

    def driver
      @driver ||= HtmlDriver.new.driver
    end

    def wait_for_elements(css_selector)
      timeout = 200
      while driver.find_elements(:css, css_selector).length == 0
        sleep 1
        timeout -= 1
        break if timeout < 1
      end
    end

    def finish
      driver.quit
    end

    def parse_show_page(index_result)
      driver.navigate.to index_result['Auction URL']
      wait_for_elements('.listing-post-title')

      doc = Nokogiri::HTML(driver.page_source)
      # create a new ResultParser object with the main page's HTML, the bio page's HTML,
      # and other data like the lawyer's office and name
      parser = ResultParser.new(doc, index_result)

      if parser.category.include?('Motorcycles') or parser.category.include?('Parts')
        return nil
      else
        {
          "Full Auction title"        => handle_nil { parser.full_auction_title },
          "Is Owned"                  => handle_nil { parser.is_owned },
          "Is it 'no reserve'"        => handle_nil { parser.is_reserve },
          "Year"                      => handle_nil { parser.year },
          "Make"                      => handle_nil { parser.make },
          "Model Family"              => handle_nil { parser.model_family },
          "Model Identifier"          => handle_nil { parser.model_identifier },
          "Era"                       => handle_nil { parser.era },
          "Origin"                    => handle_nil { parser.origin },
          "Category"                  => handle_nil { parser.category },
          "Number Of Comments"        => handle_nil { parser.number_of_comments },
          "Seller"                    => handle_nil { parser.seller },
          "Private Party Or Dealer"   => handle_nil { parser.private_party_or_dealer },
          "Ext. Color Group"          => handle_nil { parser.color[0] },
          "Int. Color Group"          => handle_nil { parser.color[1] },
          "Buyer"                     => handle_nil { parser.buyer },
          "Odometer"                  => handle_nil { parser.odometer },
          "Miles Of Kilometers"       => handle_nil { parser.miles_of_kilometers },
          "Location"                  => handle_nil { parser.location },
          "Chassis/VIN"               => handle_nil { parser.chassis_VIN },
          "Status"                    => handle_nil { parser.status },
          "Value"                     => handle_nil { parser.value },
          "Auction End Day"           => handle_nil { parser.auction_end_day },
          "Auction End Month"         => handle_nil { parser.auction_end_month },
          "Auction End Day Number"    => handle_nil { parser.auction_end_day_number },
          "Auction End Time"          => handle_nil { parser.auction_end_time },
          "Number Of Bids"            => handle_nil { parser.number_of_bids },
          "Number Of Views"           => handle_nil { parser.number_of_views },
          "Watchers"                  => handle_nil { parser.watchers },
          "Color Description"         => handle_nil { parser.color_description }
        }
      end
    end

    class ResultParser < BaseResultParser
      attr_reader :doc, :index_result

      def initialize(doc, index_result)
        @doc          = doc
        @index_result = index_result
      end

      def full_auction_title
        doc.css('.listing-post-title').text.strip
      end

      def is_owned
        if full_auction_title.include?('Owned')
          'Yes'
        else
          'No'
        end
      end

      def is_reserve
        reserve_element = doc.at('.item-tags span:contains("No Reserve")')
        if reserve_element
          return 'Yes'
        else
          return 'No'
        end
      end

      def year
        full_auction_title.scan(/\d{4}/).first
      end

      def make
        doc.css(".group-title-label:contains('Make')").map{|e| e.next.text.strip}.join(', ')
      end

      def model_family
        doc.css(".group-title-label:contains('Model')").map{|e| e.next.text.strip}.join(', ')
      end

      def model_identifier
        doc.css(".listing-nicknames a").text.strip
      end

      def era
        doc.css(".group-title-label:contains('Era')").map{|e| e.next.text.strip}.join(', ')
      end

      def origin
        doc.css(".group-title-label:contains('Origin')").map{|e| e.next.text.strip}.join(', ')
      end

      def category
        doc.css(".group-title-label:contains('Category')").map{|e| e.next.text.strip}.join(', ')
      end

      def number_of_comments
        doc.css(".comments_header_html .info-value").text.strip
      end

      def seller
        name = doc.css(".item-seller a[href^='https://bringatrailer.com/member']").text.strip
        link = doc.at(".item-seller a[href^='https://bringatrailer.com/member']")['href']
        return name + " (#{link}) "
      end

      def private_party_or_dealer
        doc.at("strong:contains('Private Party or Dealer')").next.text.gsub(': ','').strip
      end

      def color
        ex_color = ""
        in_color = ""
        doc.css("strong:contains('Listing Details')").first.parent.css('li').each_with_index.map do |e, index|
          color_txt = parse_color(e.text)
          if color_txt.nil?
            nil
          else
            ex_color = parse_color(e.text)
            in_color = parse_color(doc.css("strong:contains('Listing Details')").first.parent.css('li')[index + 1].text.strip)
            break
          end
        end
        [ex_color, in_color]
      end

      def buyer
        name = doc.at(".listing-stats-label:contains('Winning Bid')").next_element.css("a[href^='https://bringatrailer.com/member']").text.strip
        link = doc.at(".listing-stats-label:contains('Winning Bid')").next_element.at("a[href^='https://bringatrailer.com/member']")['href']
        return name + " (#{link}) "
      end

      def odometer
        doc.css("strong:contains('Listing Details')").first.parent.css('li').map do |e|
          if e.text.include?("Miles") or e.text.include?("Kilometers")
            e.text.split(" ")[0].strip
          elsif e.text.include?("TMU")
            "Unknown"
          else
            nil
          end
        end.compact[0]
      end

      def miles_of_kilometers
        doc.css("strong:contains('Listing Details')").first.parent.css('li').map do |e|
          if e.text.include?("Miles") or e.text.include?("Kilometers")
            e.text.split(" ")[1].strip
          elsif e.text.include?("TMU")
            "Unknown"
          else
            nil
          end
        end.compact[0]
      end

      def location
        doc.at("strong:contains('Location')").next_element.text.strip
      end

      def chassis_VIN
        doc.css("strong:contains('Listing Details')").first.parent.css('li').map do |e|
          if e.text.include?("Chassis")
            return e.css('a').text.strip
          else
            return nil
          end
        end.compact[0].text.strip
      end

      def status
        if doc.css(".listing-available-info .info-value.noborder-tiny").text.include?("Sold")
          return "Sold"
        else
          return "Not Sold"
        end
      end

      def value
        if doc.css(".listing-available-info .info-value.noborder-tiny").text.include?("Sold")
          return doc.css(".listing-available-info .info-value.noborder-tiny strong").text.strip
        else
          return "Bid to " + doc.css(".listing-available-info .info-value.noborder-tiny strong").text.strip
        end
      end

      def auction_end_day
        doc.at(".listing-stats-label:contains('Auction Ended')").next_element.css("span").text.split(',')[0].strip
      end

      def auction_end_month
        doc.at(".listing-stats-label:contains('Auction Ended')").next_element.css("span").text.split(',')[1].strip.split(' ')[0]
      end

      def auction_end_day_number
        doc.at(".listing-stats-label:contains('Auction Ended')").next_element.css("span").text.split(',')[1].strip.split(' ')[1]
      end

      def auction_end_time
        doc.at(".listing-stats-label:contains('Auction Ended')").next_element.css("span").text.split(',')[1].strip.split(' ')[-1]
      end

      def number_of_bids
        doc.at(".listing-stats-label:contains('Bids')").next_element.text
      end

      def number_of_views
        doc.at(".listing-stats-views span[data-stats-item='views']").text.gsub(' views','').strip
      end

      def watchers
        doc.at(".listing-stats-views span[data-stats-item='watchers']").text.gsub(' watchers','').strip
      end

      def color_description
        doc.css("strong:contains('Listing Details')").first.parent.css('li').map do |e|
          color_txt = parse_color(e.text)
          if color_txt.nil?
            nil
          else
            e.text.strip
          end
        end.compact.join(", ")
      end
    end
  end
