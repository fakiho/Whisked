//
//  IngredientEmojiMapper.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// A utility class that maps ingredient names to corresponding emojis
struct IngredientEmojiMapper {
    
    // MARK: - Static Properties
    
    /// Comprehensive mapping of ingredient keywords to emojis
    private static let emojiMapping: [String: String] = [
        // Fruits
        "apple": "🍎", "apples": "🍎", "green apple": "🍏",
        "banana": "🍌", "bananas": "🍌",
        "orange": "🍊", "oranges": "🍊",
        "lemon": "🍋", "lemons": "🍋", "lemon juice": "🍋", "lemon zest": "🍋",
        "lime": "🍋", "limes": "🍋", "lime juice": "🍋", "lime zest": "🍋",
        "strawberry": "🍓", "strawberries": "🍓",
        "cherry": "🍒", "cherries": "🍒",
        "grape": "🍇", "grapes": "🍇",
        "watermelon": "🍉",
        "peach": "🍑", "peaches": "🍑",
        "pineapple": "🍍",
        "coconut": "🥥", "coconut milk": "🥥", "coconut cream": "🥥", "coconut oil": "🥥",
        "kiwi": "🥝",
        "mango": "🥭", "mangos": "🥭",
        "blueberry": "🫐", "blueberries": "🫐",
        "raspberry": "🍓", "raspberries": "🍓",
        "blackberry": "🍇", "blackberries": "🍇",
        "cranberry": "🍒", "cranberries": "🍒",
        "avocado": "🥑",
        
        // Vegetables
        "tomato": "🍅", "tomatoes": "🍅",
        "carrot": "🥕", "carrots": "🥕",
        "onion": "🧅", "onions": "🧅",
        "garlic": "🧄",
        "potato": "🥔", "potatoes": "🥔",
        "bell pepper": "🫑", "green pepper": "🫑", "red pepper": "🫑",
        "cucumber": "🥒", "cucumbers": "🥒",
        "lettuce": "🥬",
        "spinach": "🥬",
        "broccoli": "🥦",
        "cauliflower": "🥦",
        "mushroom": "🍄", "mushrooms": "🍄",
        "corn": "🌽",
        "peas": "🟢",
        "bean": "🫘", "beans": "🫘",
        "chili": "🌶️", "chilis": "🌶️", "chili pepper": "🌶️",
        "ginger": "🫚",
        
        // Proteins & Meat
        "chicken": "🐔", "chicken breast": "🐔", "chicken thigh": "🐔",
        "beef": "🥩", "ground beef": "🥩", "steak": "🥩",
        "pork": "🐷", "bacon": "🥓", "ham": "🍖",
        "fish": "🐟", "salmon": "🐟", "tuna": "🐟", "cod": "🐟",
        "shrimp": "🦐", "prawns": "🦐",
        "crab": "🦀",
        "lobster": "🦞",
        "egg": "🥚", "eggs": "🥚",
        "turkey": "🦃",
        
        // Dairy
        "milk": "🥛", "whole milk": "🥛", "skim milk": "🥛",
        "cream": "🥛", "heavy cream": "🥛", "whipping cream": "🥛",
        "butter": "🧈", "unsalted butter": "🧈",
        "cheese": "🧀", "cheddar": "🧀", "mozzarella": "🧀", "parmesan": "🧀",
        "yogurt": "🥛", "greek yogurt": "🥛",
        "sour cream": "🥛",
        "ice cream": "🍦",
        
        // Grains & Bread
        "bread": "🍞", "white bread": "🍞", "whole wheat bread": "🍞",
        "flour": "🌾", "all-purpose flour": "🌾", "wheat flour": "🌾",
        "rice": "🍚", "white rice": "🍚", "brown rice": "🍚",
        "pasta": "🍝", "spaghetti": "🍝", "macaroni": "🍝",
        "oats": "🌾", "rolled oats": "🌾", "oatmeal": "🌾",
        "quinoa": "🌾",
        "barley": "🌾",
        "wheat": "🌾",
        "noodles": "🍜",
        
        // Nuts & Seeds
        "almond": "🌰", "almonds": "🌰",
        "walnut": "🌰", "walnuts": "🌰",
        "pecan": "🌰", "pecans": "🌰",
        "peanut": "🥜", "peanuts": "🥜", "peanut butter": "🥜",
        "cashew": "🌰", "cashews": "🌰",
        "pistachio": "🌰", "pistachios": "🌰",
        "hazelnut": "🌰", "hazelnuts": "🌰",
        "sunflower seeds": "🌻",
        "pumpkin seeds": "🎃",
        "sesame seeds": "🌾",
        
        // Spices & Herbs
        "salt": "🧂", "sea salt": "🧂", "kosher salt": "🧂",
        "black pepper": "⚫", "white pepper": "⚫", "ground pepper": "⚫",
        "cinnamon": "🟤", "ground cinnamon": "🟤",
        "vanilla": "🟤", "vanilla extract": "🟤", "vanilla essence": "🟤",
        "sugar": "🟡", "white sugar": "🟡", "brown sugar": "🟤", "powdered sugar": "🟡",
        "honey": "🍯",
        "maple syrup": "🍁",
        "basil": "🌿", "fresh basil": "🌿",
        "oregano": "🌿",
        "thyme": "🌿",
        "rosemary": "🌿",
        "parsley": "🌿", "fresh parsley": "🌿",
        "cilantro": "🌿", "fresh cilantro": "🌿",
        "dill": "🌿",
        "mint": "🌿", "fresh mint": "🌿",
        "paprika": "🌶️",
        "cumin": "🟤",
        "turmeric": "🟡",
        "curry": "🟡", "curry powder": "🟡",
        "nutmeg": "🟤",
        "cloves": "🟤",
        "cardamom": "🟤",
        "bay leaves": "🌿", "bay leaf": "🌿",
        "saffron": "🟡",
        
        // Oils & Vinegars
        "oil": "🫒", "olive oil": "🫒", "vegetable oil": "🫒", "canola oil": "🫒",
        "vinegar": "🍾", "white vinegar": "🍾", "apple cider vinegar": "🍎", "balsamic vinegar": "🍾",
        
        // Beverages
        "water": "💧",
        "wine": "🍷", "red wine": "🍷", "white wine": "🥂",
        "beer": "🍺",
        "coffee": "☕", "espresso": "☕",
        "tea": "🍵", "green tea": "🍵", "black tea": "🍵",
        "juice": "🧃", "orange juice": "🍊", "apple juice": "🍎",
        
        // Dessert Ingredients
        "chocolate": "🍫", "dark chocolate": "🍫", "milk chocolate": "🍫", "white chocolate": "🤍",
        "cocoa": "🍫", "cocoa powder": "🍫",
        "caramel": "🟤",
        "marshmallow": "🤍", "marshmallows": "🤍",
        "sprinkles": "🌈",
        "frosting": "🎂", "icing": "🎂",
        
        // Baking Essentials
        "baking powder": "🥄",
        "baking soda": "🥄",
        "yeast": "🟤",
        "cornstarch": "🌽",
        "gelatin": "🟡",
        
        // International Ingredients
        "soy sauce": "🥢",
        "fish sauce": "🐟",
        "miso": "🟤",
        "tahini": "🌰",
        "harissa": "🌶️",
        "wasabi": "🟢",
        "sriracha": "🌶️",
        
        // Canned/Packaged
        "broth": "🍲", "chicken broth": "🐔", "beef broth": "🥩", "vegetable broth": "🥬",
        "stock": "🍲", "chicken stock": "🐔", "beef stock": "🥩", "vegetable stock": "🥬",
        "tomato paste": "🍅", "tomato sauce": "🍅"
    ]
    
    // MARK: - Public Methods
    
    /// Returns the appropriate emoji for a given ingredient name
    /// - Parameter ingredientName: The name of the ingredient
    /// - Returns: An emoji string representing the ingredient, or a default emoji if no match is found
    static func emoji(for ingredientName: String) -> String {
        let normalizedName = ingredientName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // First, try exact match
        if let emoji = emojiMapping[normalizedName] {
            return emoji
        }
        
        // Then try partial matches (contains)
        for (key, emoji) in emojiMapping {
            if normalizedName.contains(key) || key.contains(normalizedName) {
                return emoji
            }
        }
        
        // Try word-by-word matching for compound ingredients
        let words = normalizedName.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .filter { !$0.isEmpty }
        
        for word in words {
            if let emoji = emojiMapping[word] {
                return emoji
            }
        }
        
        // Check for partial word matches
        for word in words {
            for (key, emoji) in emojiMapping {
                if word.contains(key) || key.contains(word) {
                    return emoji
                }
            }
        }
        
        // Category-based fallbacks
        return categoricalFallback(for: normalizedName)
    }
    
    // MARK: - Private Methods
    
    /// Provides category-based fallback emojis for unmatched ingredients
    private static func categoricalFallback(for ingredientName: String) -> String {
        let name = ingredientName.lowercased()
        
        // Powders and dry ingredients
        if name.contains("powder") || name.contains("ground") || name.contains("dried") {
            return "🥄"
        }
        
        // Liquid ingredients
        if name.contains("juice") || name.contains("liquid") || name.contains("extract") {
            return "💧"
        }
        
        // Fresh herbs (contains "fresh")
        if name.contains("fresh") && (name.contains("herb") || name.contains("leave")) {
            return "🌿"
        }
        
        // Any kind of seed
        if name.contains("seed") {
            return "🌾"
        }
        
        // Any kind of berry
        if name.contains("berry") {
            return "🍓"
        }
        
        // Any kind of sauce
        if name.contains("sauce") {
            return "🥄"
        }
        
        // Any kind of oil
        if name.contains("oil") {
            return "🫒"
        }
        
        // Default ingredient emoji
        return "🥄"
    }
}

// MARK: - Preview Helper

#if DEBUG
/// Preview helper for testing emoji mappings
struct IngredientEmojiMapper_Previews {
    static let testIngredients = [
        "Flour", "Sugar", "Eggs", "Butter", "Vanilla Extract",
        "Dark Chocolate", "Heavy Cream", "Strawberries", "Lemon Juice",
        "Fresh Basil", "Olive Oil", "Garlic", "Tomatoes", "Chicken Breast",
        "Unknown Ingredient", "Mysterious Powder"
    ]
    
    static func printMappings() {
        print("=== Ingredient Emoji Mappings ===")
        for ingredient in testIngredients {
            let emoji = IngredientEmojiMapper.emoji(for: ingredient)
            print("\(ingredient): \(emoji)")
        }
    }
}
#endif