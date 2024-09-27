/*
Author: Aidan Elm
Assignment: Assignment 2
Class: Database Management Systems
Date: 2024-09-26
*/

-- ** Problem 1 **
SELECT restaurants.restID, restaurants.name, AVG(foods.price)
FROM restaurants
JOIN serves ON restaurants.restID = serves.restID
JOIN foods ON serves.foodID = foods.foodID
GROUP BY restaurants.restID, restaurants.name;

-- ** Problem 2 **
SELECT restaurants.restID, restaurants.name, MAX(foods.price)
FROM restaurants
JOIN serves ON restaurants.restID = serves.restID
JOIN foods ON serves.foodID = foods.foodID
GROUP BY restaurants.restID, restaurants.name;

-- ** Problem 3 **
SELECT restaurants.restID, restaurants.name, COUNT(DISTINCT foods.type)
FROM restaurants
JOIN serves ON restaurants.restID = serves.restID
JOIN foods ON serves.foodID = foods.foodID
GROUP BY restaurants.restID, restaurants.name;

-- ** Problem 4 **
SELECT chefs.chefID, chefs.name, AVG(foods.price)
FROM chefs
JOIN works on chefs.chefID = works.chefID
JOIN serves on works.restID = serves.restID
JOIN foods on serves.foodID = foods.foodID
GROUP BY chefs.chefID, chefs.name;

-- ** Problem 5 **
SELECT restaurants.name, AVG(foods.price)
FROM restaurants
JOIN serves ON restaurants.restID = serves.restID
JOIN foods ON serves.foodID = foods.foodID
GROUP BY restaurants.name
ORDER BY AVG(foods.price) DESC
LIMIT 1;