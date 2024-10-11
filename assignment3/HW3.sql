/*
Author: Aidan Elm
Assignment: Assignment 3
Class: Database Management Systems
Date: 2024-10-10
*/

-- ** Table Creation **

-- create merchants table
create table merchants (
    mid int primary key,
    name varchar(100) not null,
    city varchar(100),
    state varchar(100)
);

-- create products table
create table products (
    pid int primary key,
    name varchar(100) not null,
    category varchar(100),
    description varchar(1000),
    constraint check_product_name check (name in ('printer', 'ethernet adapter', 'desktop', 'hard drive', 'laptop', 'router', 'network card', 'super drive', 'monitor')),
    constraint check_product_category check (category in ('peripheral', 'networking', 'computer'))
);

-- create sell table
create table sell (
    mid int,
    pid int,
    price decimal(10, 2) not null,
    quantity_available int not null,
    primary key (mid, pid),
    foreign key (mid) references merchants(mid),
    foreign key (pid) references products(pid),
    constraint check_price check (price between 0 and 100000),
    constraint check_quantity check (quantity_available between 0 and 1000)
);

-- create orders table
create table orders (
    oid int primary key,
    shipping_method varchar(100),
    shipping_cost decimal(10, 2),
    constraint check_shipping_method check (shipping_method in ('ups', 'fedex', 'usps')),
    constraint check_shipping_cost check (shipping_cost between 0 and 500)
);

-- create contain table
create table contain (
    oid int,
    pid int,
    primary key (oid, pid),
    foreign key (oid) references orders(oid),
    foreign key (pid) references products(pid)
);

-- create customers table
create table customers (
    cid int primary key,
    fullname varchar(100) not null,
    city varchar(100),
    state varchar(100)
);

-- create place table
create table place (
    cid int,
    oid int,
    order_date date not null,
    primary key (cid, oid),
    foreign key (cid) references customers(cid),
    foreign key (oid) references orders(oid),
    constraint check_order_date check (order_date = date(order_date))
);

-- ** Problem 1 **
select p.name, m.name
from products p
join sell s on p.pid = s.pid
join merchants m on s.mid = m.mid
where s.quantity_available = 0;

-- ** Problem 2 **
select p.name, p.description
from products p
left join sell s on p.pid = s.pid
where s.pid is null;

-- ** Problem 3 **
select count(distinct c.cid)
from customers c
join place pl on c.cid = pl.cid
join orders o on pl.oid = o.oid
join contain ct on o.oid = ct.oid
join products p on ct.pid = p.pid
where p.description like '%sata%'
and c.cid not in (
    select c.cid
    from customers c
    join place pl on c.cid = pl.cid
    join orders o on pl.oid = o.oid
    join contain ct on o.oid = ct.oid
    join products p on ct.pid = p.pid
    where p.description like '%router%'
);

-- ** Problem 4 **
select p.name as product_name, s.price * 0.8
from products p
join sell s on p.pid = s.pid
join merchants m on s.mid = m.mid
where m.name like '%hp%' and p.category = 'networking';

-- ** Problem 5 **
select p.name, s.price
from customers c
join place pl on c.cid = pl.cid
join orders o on pl.oid = o.oid
join contain ct on o.oid = ct.oid
join products p on ct.pid = p.pid
join sell s on p.pid = s.pid
where c.fullname like '%Uriel Whitney%' and p.name like '%Acer%';

-- ** Problem 6 **
select merchants.name, year(place.order_date), count(distinct orders.oid) 
from merchants 
join sell on merchants.mid = sell.mid 
join contain on sell.pid = contain.pid 
join orders on contain.oid = orders.oid 
join place on orders.oid = place.oid 
group by merchants.name, year(place.order_date) 
order by merchants.name, year(place.order_date);

-- ** Problem 7 **
select merchants.name, year(place.order_date), count(distinct orders.oid) 
from merchants 
join sell on merchants.mid = sell.mid 
join contain on sell.pid = contain.pid 
join orders on contain.oid = orders.oid 
join place on orders.oid = place.oid 
group by merchants.name, year(place.order_date) 
order by count(distinct orders.oid) desc 
limit 1;

-- ** Problem 8 **
select shipping_method, avg(shipping_cost)
from orders
group by shipping_method
order by avg(shipping_cost) asc
limit 1;

-- ** Problem 9 **
select merchants.name, products.category, count(distinct orders.oid)
from merchants 
join sell on merchants.mid = sell.mid 
join contain on sell.pid = contain.pid 
join orders on contain.oid = orders.oid 
join products on sell.pid = products.pid 
group by merchants.name, products.category 
order by merchants.name, count(distinct orders.oid) desc;

-- ** Problem 10 **
select merchants.name, customers.fullname, count(distinct orders.oid)
from merchants 
join sell on merchants.mid = sell.mid 
join contain on sell.pid = contain.pid 
join orders on contain.oid = orders.oid 
join place on orders.oid = place.oid 
join customers on place.cid = customers.cid 
group by merchants.name, customers.fullname 
order by merchants.name, count(distinct orders.oid);