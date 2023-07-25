require 'pry'
require 'csv'
require 'base64'
require_relative './html_driver'
# require_relative './cli'

Dir[File.dirname(__FILE__) + '/firms/*rb'].each { |file| load file }
Dir[File.dirname(__FILE__) + '/firms/*/*rb'].each { |file| load file }


# BringatrailerIndexScraper.new.scrape_html
# CovingtonShowScraper.new.download_html
BringatrailerShowParser.new.parse_show

# QuinnEmanuelIndexScraper.new.scrape_html
# QuinnEmanuelShowScraper.new.download_html
# QuinnEmanuelShowParser.new.parse_show

# DebevoiseIndexScraper.new.scrape_html
# DebevoiseShowScraper.new.download_html
# DebevoiseShowParser.new.parse_show

# RopesgrayIndexScraper.new.scrape_html
# RopesgrayShowScraper.new.download_html
# RopesgrayShowParser.new.parse_show

# WcIndexScraper.new.scrape_html
# WcShowScraper.new.download_html
# WcShowParser.new.parse_show

# MorrisonFoersterIndexScraper.new.scrape_html
# MorrisonFoersterShowScraper.new.download_html
# MorrisonFoersterShowParser.new.parse_show

# WilmerhaleIndexScraper.new.scrape_html
# WilmerhaleShowScraper.new.download_html
# WilmerhaleShowParser.new.parse_show

# BakerMckenzieIndexScraper.new.scrape_html
# BakerMckenzieShowScraper.new.download_html
# BakerMckenzieShowParser.new.parse_show

# WilsonSonsiniIndexScraper.new.scrape_html
# WilsonSonsiniShowScraper.new.download_html
# WilsonSonsiniShowParser.new.parse_show

# HoganlovellsIndexScraper.new.scrape_html
# HoganlovellsShowScraper.new.download_html
# HoganlovellsShowParser.new.parse_show

# McdermottwillEmeryIndexScraper.new.scrape_html
# McdermottwillEmeryShowScraper.new.download_html
# McdermottwillEmeryShowParser.new.parse_show
# FirmAnalyzer.new("mcdermottwill_emery").run

# DechertIndexScraper.new.scrape_html
# DechertShowScraper.new.download_html
# DechertShowParser.new.parse_show

# AllenOveryIndexScraper.new.scrape_sitemap
# AllenOveryShowScraper.new.download_html
# AllenOveryShowParser.new.parse_show

# BakerbottsIndexScraper.new.scrape_sitemap
# BakerbottsShowScraper.new.download_html
# BakerbottsShowParser.new.parse_show
# FirmAnalyzer.new("bakerbotts").run

# BoiesschillerflexnerIndexScraper.new.scrape_sitemap
# BoiesschillerflexnerShowScraper.new.download_html
# BoiesschillerflexnerShowParser.new.parse_show

# KLgatesIndexScraper.new.scrape_html
# KLgatesShowScraper.new.download_html
# KLgatesShowParser.new.parse_show
# FirmAnalyzer.new("k_lgates").run

# PillsburyIndexScraper.new.scrape_sitemap
# PillsburyShowScraper.new.download_html
# PillsburyShowParser.new.parse_show

# McdermottwillEmeryIndexScraper.new.scrape_html
# McdermottwillEmeryShowScraper.new.download_html
# McdermottwillEmeryShowParser.new.parse_show
# FirmAnalyzer.new("mcdermottwill_emery").run

# ShearmanSterlingIndexScraper.new.scrape_sitemap
# ShearmanSterlingShowScraper.new.download_html
# ShearmanSterlingShowParser.new.parse_show

# Pry.start
# FirmAnalyzer.new("shearman_sterling").run

# GreenbergtraurigIndexScraper.new.scrape_sitemap
# GreenbergtraurigShowScraper.new.download_html
# GreenbergtraurigShowParser.new.parse_show
# FirmAnalyzer.new("greenbergtraurig").run
# HollandKnightIndexScraper.new.scrape_sitemap
# HollandKnightShowScraper.new.download_html
# HollandKnightShowParser.new.parse_show
# FirmAnalyzer.new("holland_knight").run

# VinsonElkinsIndexScraper.new.scrape_sitemap
# VinsonElkinsShowScraper.new.download_html
# VinsonElkinsShowParser.new.parse_show
# FirmAnalyzer.new("vinson_elkins").run

# BallardspahrIndexScraper.new.scrape_sitemap
# BallardspahrShowScraper.new.download_html
# BallardspahrShowParser.new.parse_show
# FirmAnalyzer.new("ballardspahr").run

# BlankromeIndexScraper.new.scrape_html
# BlankromeShowScraper.new.download_html
# BlankromeShowParser.new.parse_show
# FirmAnalyzer.new("blankrome").run

# ArentfoxschiffIndexScraper.new.scrape_html
# ArentfoxschiffShowScraper.new.download_html
# ArentfoxschiffShowParser.new.parse_show

# FirmAnalyzer.new("arentfoxschiff").run
# BakerhostetlerIndexScraper.new.scrape_html
# BakerhostetlerShowScraper.new.download_html
# BakerhostetlerShowParser.new.parse_show
# FirmAnalyzer.new("bakerhostetler").run

# S3Syncer.new.sync_to_s3

# DentonsIndexScraper.new.scrape_html
# DentonsShowScraper.new.download_html
# DentonsShowParser.new.parse_show
# FirmAnalyzer.new("dentons").run

# BryancaveleightonpaisnerIndexScraper.new.scrape_sitemap
# BryancaveleightonpaisnerShowScraper.new.download_html
# BryancaveleightonpaisnerShowParser.new.parse_show
# FirmAnalyzer.new("bryancaveleightonpaisner").run
