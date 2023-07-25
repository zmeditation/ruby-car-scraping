require_relative 'show_scraper'
class WilsonSonsiniShowParser < BaseShowParser
    def initialize
      super("wilson_sonsini")
    end

    def parse_show_page(doc, missing_locations, missing_degree, office, index_result)
    
      # create a new ResultParser object with the main page's HTML, the bio page's HTML,
      # and other data like the lawyer's office and name
      parser = ResultParser.new(doc, office, index_result)
      
      # add any missing location data to the `missing_locations` array
      missing_locations << parser.missing_location if parser.missing_location

      missing_degree << parser.missing_degree
    
      # create a hash of lawyer information from the parsed HTML
      {
        "law_level"        => handle_nil { parser.law_level },
        "email"            => handle_nil { parser.email },
        "phone"            => handle_nil { parser.phone },
        "raw_educations"   => handle_nil { parser.raw_educations },
        "educations"       => handle_nil { parser.educations },
        "description"      => handle_nil { parser.description },
        "location"         => handle_nil { parser.parsed_location },
        "practice_areas"   => handle_nil { parser.practice_areas },
        "bar_associations" => handle_nil { parser.bar_associations },
        "office"           => office,
        "image_url"        => handle_nil { parser.image_url },
      }
    end

    class ResultParser < BaseResultParser
      attr_reader :doc, :missing_location, :office, :index_result

      def initialize(doc, office, index_result)
        @doc          = doc
        @office       = office
        @index_result = index_result
      end

      def law_level
        doc.css('.bio-header-info__position--b5345eef').text.strip
      end

      def raw_educations
        doc.at(".tabs__subsectionTitle--_ac496bc:contains('Education')").next_element.css('li').map(&:text)
      end

      def educations
        raw_educations.map do |education|
          parse_education(education)
        end
      end

      def parse_education(education)
        text = education
        university = ""
        if text.scan(/\d{4}/).first.nil?
          university = text.gsub(parse_education_degree(education)+', ' , '')
        else
          university = text.gsub(parse_education_degree(education)+', ' , '').gsub(', ' + text.scan(/\d{4}/).first, '')
        end
        
        {
          university: university,
          graduation_year: text.scan(/\d{4}/).first,
          degree: parse_education_degree(education),
        }
      end

      def practice_areas
        doc.css(".styles__relatedServicesContainer--d7c0b468 ul").first.css("li").map(&:text).map(&:strip)
      end

      def description
        doc.css('.tabs__tabPane--_d70500c').map{|e| e}[0].css('.tabs__subsection--_f0f2a64').text.gsub(/\s+/," ").strip
      end

      def bar_associations
        doc.at(".tabs__subsectionTitle--_ac496bc:contains('Admissions')").next_element.css('li').map(&:text)
      end

      def missing_location
        location if !parsed_location
      end

      def missing_degree
        raw_educations.map{ |e| e if !parse_education_degree(e) }.compact
      end

      def location
        if office && office.length > 0
          office.split(",")[0]
        end
      end

      def parsed_location
        parse_location(location)
      end

      def email
        doc.css(".bio-header-info__email--_7c8f978").text.strip
      end

      def phone
        '+1' + doc.at('.bio-header-info__mainPhone--_dca8fa9').text.strip.gsub('D ', '').gsub('-', ' ')
      end

      def image_url
        doc.at_css('.styles__bioPhotoContainer--_9413933 img')['src']
      end

    end
  end
