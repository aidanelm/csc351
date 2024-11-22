/*
Author: Aidan Elm
Assignment: DBMS Assignment 5
Class: Database Management Systems
Date: 2024-11-21
*/

// Question 1
db.unemployment.distinct("Year").length

// Question 2
db.unemployment.distinct("State").length

// Answer to 3 is 657

// Question 4
db.unemployment.find({Rate: {$gt: 10.0}}, {County: 1})

// Question 5
db.unemployment.aggregate([{$group: {averageRate: {$avg: "$Rate"}, _id: null}}])

// Question 6
db.unemployment.find({Rate: {$gte: 5.0, $lte: 8.0}}, {County: 1})

// Question 7
db.unemployment.aggregate([{$group: {_id: "$State", avgRate: {$avg: "$Rate"}}}, {$sort: {avgRate: -1}}, {$limit: 1}])

// Question 8
db.unemployment.find({Rate: {$gt: 5.0}}, {County: 1}).count()

// Question 9
db.unemployment.aggregate([{$group: {_id: {state: "$State", year: "$Year"}, avgRate: {$avg: "$Rate"}}}])

// Question 10
db.unemployment.aggregate([{$group: {_id: "$State", totalRate: {$sum: "$Rate"}}}])

// Question 11
db.unemployment.aggregate([{$match: {Year: {$gte: 2015}}}, {$group: {_id: "$State", totalRate: {$sum: "$Rate"}}}])