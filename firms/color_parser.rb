class ColorParser
    COLORS = [
        "White",
        "Black",
        "Orange",
        "Maroon",
        "Red",
        "Yellow",
        "Lime green",
        "Salmon",
        "Green",
        "Sky blue",
        "Crimson",
        "Aqua",
        "Grey",
        "Purple",
        "Mustard",
        "Peach",
        "Violet",
        "Magenta",
        "Coral",
        "Saffron",
        "Brown",
        "Pink",
        "Tan",
        "Teal",
        "Navy", 
        "Blue",
        "Turquoise",
        "Lavender",
        "Beige",
        "Lemon yellow",
        "Grape vine",
        "Indigo",
        "Fuchsia",
        "Amber",
        "Sea green",
        "Dark green",
        "Burgundy",
        "Charcoal",
        "Bronze",
        "Cream",
        "Mauve",
        "Olive",
        "Cyan",
        "Silver",
        "Rust",
        "Ruby",
        "Azure",
        "Mint",
        "Pearl",
        "Ivory",
        "Tangerine",
        "Cherry red",
        "Garnet",
        "Emerald",
        "Sapphire",
        "Rosewood",
        "Lilac",
        "Arctic blue",
        "Pista green",
        "Coffee brown",
        "Umber",
        "Brunette",
        "Mocha",
        "Ash",
        "Jet black",      
    ]
  
    def self.parse(string)
  
        colors = COLORS.sort_by!(&:length).reverse!

        match_color = colors.find do |color|
            reg = Regexp.new("\\b#{color}\\b", Regexp::IGNORECASE)
            string =~ reg
        end
  
        match_color
    end
  end
  