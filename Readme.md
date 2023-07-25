bundle install
ruby main.rb


1. Scrape index for all urls, and save to json.
2. Download all HTML
3. Parse the HTML, extract the data, and save to json

<!-- 1. Scrape index for all urls  -->
CovingtonIndexScraper.new.scrape_html

<!-- 2. Download all HTML  -->
CovingtonShowScraper.new.download_html

<!-- 3. Parse the HTML -->
CovingtonShowScraper.new.parse_show


<!-- Example object we want -->
  <!-- {
    "name": "William H. Aaronson",
    "first_name": "William",
    "last_name": "Aaronson",
    "law_level": "Partner",
    "office": "New York",
    "phone": "+1 212 450 4397",
    "email": "william.aaronson@davispolk.com",
    "practice_areas": [
      "Mergers & Acquisitions",
      "ESG",
      "Europe",
      "Fintech & Cryptocurrency",
      "Healthcare & Life Sciences",
      "Israel",
      "Public Company Advisory",
      "Sports"
    ],
    "profile_url": "/lawyers/william-aaronson",
    "full_url": "https://www.davispolk.com/lawyers/william-aaronson",
    "raw_educations": [
      "J.D., Harvard Law School",
      "B.A., Johns Hopkins University"
    ],
    "educations": [
      {
        "university": " Harvard Law School",
        "graduation_year": null,
        "degree": "J.D."
      },
      {
        "university": " Johns Hopkins University",
        "graduation_year": null,
        "degree": "B.A."
      }
    ],
    "bar_associations": [
      "State of California",
      "State of New York"
    ],
    "description": "Co-head of Mergers & Acquisitions. Advises clients on public and private M&A transactions, joint ventures, shareholder activism and general corporate matters. Will is co-head of our Mergers & Acquisitions group. He advises clients on public and private M&A transactions, joint ventures and other corporate partnering arrangements. He also advises companies on corporate governance matters, shareholder activism and general corporate matters.",
    "law_firm": "Davis Polk & Wardwell LLP",
    "experience": null,
    "location": {
      "city": "New York",
      "state": "New York",
      "country": "United States"
    },
    "image_url": "https://www.davispolk.com/sites/default/files/lawyer-images/18966_waaron.jpg"
  }, -->
