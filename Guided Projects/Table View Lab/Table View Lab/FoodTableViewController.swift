//
//  FoodTableViewController.swift
//  Table View Lab
//
//  Created by Student on 18/08/25.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    var meals: [Meal] {
        let breakfastFoods = [
            Food(name: "Cereal", description: "Honey Nut"),
            Food(name: "Scrambled Eggs", description: "Soft and creamy Gordon Ramsey style"),
            Food(name: "Coffee", description: "Hot")
        ]
        let breakfast = Meal(name: "Breakfast", food: breakfastFoods)
        
        let lunchFoods = [
            Food(name: "Grilled Chicken Sandwich", description: "Served with sauted aspragus and carrots"),
            Food(name: "Chicken Garlic Biryani", description: "Spicy rice dish with raita dressing"),
            Food(name: "Lassi", description: "Sweetened")
        ]
        let lunch = Meal(name: "Lunch", food: lunchFoods)
        
        let dinnerFoods = [
            Food(name: "Chicken Tikka", description: "Smoked in Tandoor"),
            Food(name: "Aglio Olio Spaghetti Pasta", description: "Creamy and buttery"),
            Food(name: "Red Wine", description: "Smooth and full-bodied")
        ]
        let dinner = Meal(name: "Dinner", food: dinnerFoods)
        
        return [breakfast, lunch, dinner]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section].food.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        
        let meal = meals[indexPath.section]
        let foodItem = meal.food[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = foodItem.name
        content.secondaryText = foodItem.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].name
    }
}
