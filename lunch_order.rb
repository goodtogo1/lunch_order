@entree_menu = [
  {food: "Hamburger", price: 500, description: "A Kobe beef burger cooked to order", nutrition: {fat: 50, carbs: 70, protein: 25}},
  {food: "Hot dog", price: 450, description: "You've never had such a good hot dog", nutrition: {fat: 60, carbs: 65, protein: 15}},
  {food: "Sushi", price: 700, description: "An assortment of premium rolls", nutrition: {fat: 12, carbs: 55, protein: 20}},
  {food: "No entree", price: 0, description: "The diet option", nutrition: {fat: 0, carbs: 0, protein: 0}}
]
@sides_menu = [
  {food: "Broccoli", price: 200, description: "Broccoli that George Bush would eat", nutrition: {fat: 3, carbs: 20, protein: 4}},
  {food: "Green beans", price: 250, description: "Artisanal beans", nutrition: {fat: 4, carbs: 22, protein: 4.5}},
  {food: "Spinach", price: 300, description: "Worthy of Popeye's mouth", nutrition: {fat: 3.5, carbs: 11, protein: 5.5}},
  {food: "Carrots", price: 150, description: "Cooked in truffle butter", nutrition: {fat: 7, carbs: 33, protein: 2.5}},
  {food: "No side", price: 0, description: "For those slimming down", nutrition: {fat: 0, carbs: 0, protein: 0}}
]

@addons_menu =[
  {food: "Cookie", price: 100, description: "An oversized chocolate chip cookie", nutrition: {fat: 20, carbs: 30, protein: 5}},
  {food: "Ketchup", price: 55, description: "Made with the finest spices", nutrition: {fat: 10, carbs: 5, protein: 2}},
  {food: "Mustard", price: 40, description: "Grey Poupon", nutrition: {fat: 9, carbs: 6, protein: 3}},
  {food: "Soy Sauce", price: 70, description: "Our chef's secret sauce", nutrition: {fat: 8, carbs: 3, protein: 3.5}},
  {food: "No add-ons", price: 0, description: "Low fat and low carb", nutrition: {fat: 0, carbs: 0, protein: 0}}
]

def main
  budget, total = get_budget
  entree, side1, side2, addons, budget, total, fat, carbs, protein = new_order(budget, total)
  puts "\nYou ordered:"
  puts "\n#{entree[:food]} -- #{entree[:description]} -- $#{"%.2f" %(entree[:price].to_f / 100)}"
  puts "#{side1[:food]} -- #{side1[:description]} -- $#{"%.2f" %(side1[:price].to_f / 100)}"
  puts "#{side2[:food]} -- #{side2[:description]} -- $#{"%.2f" %(side2[:price].to_f / 100)}"
  puts "#{addons[:food]} -- #{addons[:description]} -- $#{"%.2f" %(addons[:price].to_f / 100)}"
  puts "\nYour order contains #{fat}g of fat, #{carbs}g of carbs, and #{protein}g of protein."
  puts "\nThe total bill for your order is $#{"%.2f" %(total.to_f / 100)}, leaving you $#{"%.2f" %((budget.to_f - total.to_f) / 100)} of your $#{"%.2f" %(budget.to_f / 100)} budget remaining."
  print "\nPlace order? (Y/N): "
  confirm = gets.strip.downcase
  exit if confirm == "quit"
  if confirm == "y"
    puts "\nOrder submitted! Your order number is #{rand(1000)}."
    puts
    exit
  elsif confirm == "n"
    print "\nDo you want to change your order? (Y/N): "
    change = gets.strip.downcase
    exit if change == "quit"
    if change == "y"
      entree.clear
      side1.clear
      side2.clear
      addons.clear
      main
    elsif change == "n"
      puts "\nOrder submitted! Your order number is #{rand(1000)}."
      puts
      exit
    else
      puts "\nI didn't understand your selection. Please start again."
      entree.clear
      side1.clear
      side2.clear
      addons.clear
      main
    end
  else
    puts "\nI didn't understand your selection. Please start again."
    entree.clear
    side1.clear
    side2.clear
    addons.clear
    main
  end
end

def get_budget
  print "\nHow much money do you have to spend on lunch? (Example: $12 or $12.00) $"
  budget = gets.strip
  exit if budget == "quit"
  budget = budget.to_f * 100
  budget = budget.to_i
  if budget < 40
    puts "\nSorry, the cafeteria doesn't have any items less than 40 cents."
    puts "Please come back when you have more money. Goodbye."
    puts
    exit
  end
  total = 0
  return budget, total
end

def new_order(budget, total)
  fat = 0
  carbs = 0
  protein = 0
  entree, budget, total, fat, carbs, protein = get_entree(budget, total, fat, carbs, protein)
  side1, budget, total, fat, carbs, protein, no_sides = get_side1(budget, total, fat, carbs, protein)
  unless no_sides == true
    side2, budget, total, fat, carbs, protein = get_side2(budget, total, fat, carbs, protein)
  end
  addons, budget, total, fat, carbs, protein = get_addons(budget, total, fat, carbs, protein)
  return entree, side1, side2, addons, budget, total, fat, carbs, protein
end

def get_entree(budget, total, fat, carbs, protein)
  puts "\nWhat will you have as your entree?\n\n"
  @entree_menu.each_with_index do |x, index|
    puts "(#{index + 1}) #{x[:food]}: $#{"%.2f" %(x[:price].to_f / 100)}"
    end
  print "\nEnter selection number or 'info' for menu descriptions and nutritional information: "
  selection = gets.strip
  exit if selection == "quit"
  if selection == "info"
    puts
    @entree_menu.each do |x|
      puts "#{x[:food]} -- #{x[:description]} -- Contains #{x[:nutrition][:fat]}g fat, #{x[:nutrition][:carbs]}g carbohydrates, and #{x[:nutrition][:protein]}g protein."
    end
    get_entree(budget, total, fat, carbs, protein)
  else
    entree = @entree_menu[selection.to_i - 1].clone
    price = @entree_menu[selection.to_i - 1][:price]
    if (price + total) > budget
      puts "\nSorry, that selection would bring your total to $#{"%.2f" %((price.to_f + total.to_f) / 100)}, which is over your budget of $#{"%.2f" %(budget.to_f / 100)}"
      puts "\nPlease make another selection."
      entree.clear
      get_entree(budget, total, fat, carbs, protein)
    else
      total += price
      puts "\n#{entree[:food]} was added to your order. Your total bill is currently $#{"%.2f" %(total.to_f / 100)}."
      fat += @entree_menu[selection.to_i - 1][:nutrition][:fat].to_f
      carbs += @entree_menu[selection.to_i - 1][:nutrition][:carbs].to_f
      protein += @entree_menu[selection.to_i - 1][:nutrition][:protein].to_f
      return entree, budget, total, fat, carbs, protein
    end
  end
end

def get_side1(budget, total, fat, carbs, protein)
  puts "\nWhat will be your first side?\n\n"
  @sides_menu.each_with_index do |x, index|
    puts "(#{index + 1}) #{x[:food]}: $#{"%.2f" %(x[:price].to_f / 100)}"
    end
  print "\nEnter selection number or 'info' for menu descriptions and nutritional information: "
  selection = gets.strip
  exit if selection == "quit"
  if selection == "info"
    puts
    @sides_menu.each do |x|
      puts "#{x[:food]} -- #{x[:description]} -- Contains #{x[:nutrition][:fat]}g fat, #{x[:nutrition][:carbs]}g carbohydrates, and #{x[:nutrition][:protein]}g protein."
    end
    get_side1(budget, total, fat, carbs, protein)
  else
    side1 = @sides_menu[selection.to_i - 1].clone
    price = @sides_menu[selection.to_i - 1][:price]
    if (price + total) > budget
      puts "\nSorry, that selection would bring your total to $#{"%.2f" %((price.to_f + total.to_f) / 100)}, which is over your budget of $#{"%.2f" %(budget.to_f / 100)}"
      puts "\nPlease make another selection."
      side1.clear
      get_side1(budget, total, fat, carbs, protein)
    else
      total += price
      puts "\n#{side1[:food]} was added to your order. Your total bill is currently $#{"%.2f" %(total.to_f / 100)}."
      fat += @sides_menu[selection.to_i - 1][:nutrition][:fat].to_f
      carbs += @sides_menu[selection.to_i - 1][:nutrition][:carbs].to_f
      protein += @sides_menu[selection.to_i - 1][:nutrition][:protein].to_f
      return side1, budget, total, fat, carbs, protein
    end
  end
end

def get_side2(budget, total, fat, carbs, protein)
  puts "\nWhat will be your second side?\n\n"
  @sides_menu.each_with_index do |x, index|
    puts "(#{index + 1}) #{x[:food]}: $#{"%.2f" %(x[:price].to_f / 100)}"
    end
  print "\nEnter selection number or 'info' for menu descriptions and nutritional information: "
  selection = gets.strip
  exit if selection == "quit"
  if selection == "info"
    puts
    @sides_menu.each do |x|
      puts "#{x[:food]} -- #{x[:description]} -- Contains #{x[:nutrition][:fat]}g fat, #{x[:nutrition][:carbs]}g carbohydrates, and #{x[:nutrition][:protein]}g protein."
    end
    get_side2(budget, total, fat, carbs, protein)
  else
    side2 = @sides_menu[selection.to_i - 1].clone
    price = @sides_menu[selection.to_i - 1][:price]
    if (price + total) > budget
      puts "\nSorry, that selection would bring your total to $#{"%.2f" %((price.to_f + total.to_f) / 100)}, which is over your budget of $#{"%.2f" %(budget.to_f / 100)}"
      puts "\nPlease make another selection."
      side2.clear
      get_side2(budget, total, fat, carbs, protein)
    else
      total += price
      puts "\n#{side2[:food]} was added to your order. Your total bill is currently $#{"%.2f" %(total.to_f / 100)}."
      fat += @sides_menu[selection.to_i - 1][:nutrition][:fat].to_f
      carbs += @sides_menu[selection.to_i - 1][:nutrition][:carbs].to_f
      protein += @sides_menu[selection.to_i - 1][:nutrition][:protein].to_f
      return side2, budget, total, fat, carbs, protein
    end
  end
end

def get_addons(budget, total, fat, carbs, protein)
  puts "\nWould you like any add-ons?\n\n"
  @addons_menu.each_with_index do |x, index|
    puts "(#{index + 1}) #{x[:food]}: $#{"%.2f" %(x[:price].to_f / 100)}"
    end
  print "\nEnter selection number or 'info' for menu descriptions and nutritional information: "
  selection = gets.strip
  exit if selection == "quit"
  if selection == "info"
    puts
    @addons_menu.each do |x|
      puts "#{x[:food]} -- #{x[:description]} -- Contains #{x[:nutrition][:fat]}g fat, #{x[:nutrition][:carbs]}g carbohydrates, and #{x[:nutrition][:protein]}g protein."
    end
    get_addons(budget, total, fat, carbs, protein)
  else
    addon = @addons_menu[selection.to_i - 1].clone
    price = @addons_menu[selection.to_i - 1][:price]
    if (price + total) > budget
      puts "\nSorry, that selection would bring your total to $#{"%.2f" %((price.to_f + total.to_f) / 100)}, which is over your budget of $#{"%.2f" %(budget.to_f / 100)}"
      puts "\nPlease make another selection."
      addon.clear
      get_addons(budget, total, fat, carbs, protein)
    else
      total += price
      puts "\n#{addon[:food]} was added to your order. Your total bill is currently $#{"%.2f" %(total.to_f / 100)}."
      fat += @addons_menu[selection.to_i - 1][:nutrition][:fat].to_f
      carbs += @addons_menu[selection.to_i - 1][:nutrition][:carbs].to_f
      protein += @addons_menu[selection.to_i - 1][:nutrition][:protein].to_f
      return addon, budget, total, fat, carbs, protein
    end
  end
end

puts "\nWelcome to the cafeteria. Enter 'quit' at any prompt to exit."
main
