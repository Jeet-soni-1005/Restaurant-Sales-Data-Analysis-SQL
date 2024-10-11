# Restaurant Sales Data SQL Project

## Overview
This project is designed to manage and analyze the sales data of a restaurant that sells different types of pizzas. The SQL program provides solutions for tracking orders, calculating revenue, and analyzing various trends like popular pizza types, sizes, and revenue distribution.

The project uses SQL queries to extract valuable insights from the data, such as total revenue, the most ordered pizzas, revenue by category, and cumulative sales over time.

## Prerequisites
- MySQL or any other SQL-compatible database system.
- Basic understanding of SQL for running and modifying the queries.
- CSV datasets for tables such as `orders`, `order_details`, `pizzas`, and `pizza_types` (if you are importing data manually).

## Database Schema
The database consists of four tables:

1. **orders**:
   - `order_id` (INT): Unique identifier for each order.
   - `order_date` (DATE): Date of the order.
   - `order_time` (TIME): Time when the order was placed.

2. **order_details**:
   - `order_details_id` (INT): Unique identifier for each order detail.
   - `order_id` (INT): Foreign key referencing the `orders` table.
   - `pizza_id` (TEXT): Foreign key referencing the `pizzas` table.
   - `quantity` (INT): Number of pizzas ordered.

3. **pizzas**:
   - `pizza_id` (TEXT): Unique identifier for each pizza.
   - `pizza_type_id` (TEXT): Foreign key referencing the `pizza_types` table.
   - `size` (TEXT): Size of the pizza (e.g., small, medium, large).
   - `price` (FLOAT): Price of the pizza.

4. **pizza_types**:
   - `pizza_type_id` (TEXT): Unique identifier for each pizza type.
   - `name` (TEXT): Name of the pizza type.
   - `category` (TEXT): Category of the pizza (e.g., vegetarian, non-vegetarian).
   - `ingredients` (TEXT): List of ingredients used.

## How to Run
1. **Database Setup**:
   - Use the `CREATE DATABASE restaurant_sales_data;` command to create a new database.
   - Use the provided `CREATE TABLE` statements to set up the required tables.

2. **Data Import**:
   - Import the CSV files into their respective tables using the table data import wizard in MySQL or any other SQL-compatible database system.

3. **Execute Queries**:
   - Run the SQL queries from the uploaded SQL file to generate insights like total revenue, top pizzas by category, and cumulative revenue.

## Additional Notes
- The project focuses on querying data for insights, such as sales performance, popular pizza types, and revenue distribution.
- Queries involving ranking (e.g., top 3 most ordered pizza types) use window functions like `RANK()`, which are supported by most modern SQL systems.
