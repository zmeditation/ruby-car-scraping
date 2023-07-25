class BringatrailerShowScraper < BaseShowScraper

  def initialize
    super("bringatrailer")
  end

  def should_remove_file?(doc)
    false
  end

  def include_user_agent_header?
    true
  end
end
