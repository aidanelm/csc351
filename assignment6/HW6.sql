/*
Author: Aidan Elm
Assignment: Assignment 6
Class: Database Management Systems
Date: 2024-12-10
*/

-- *** Problem 1 ***

delimiter $$
create procedure generate_accounts()
begin
    create table accounts (
        account_num int(5),
        branch_name varchar(255),
        balance decimal(10, 2),
        account_type varchar(50)
    );
end $$
delimiter ;

call generate_accounts();

-- *** Problem 2 ***

delimiter $$
create procedure populate_accounts(record_count int)
begin
    declare i int;
    set i = 1;
    while i <= record_count do
        insert into accounts (account_num, branch_name, balance, account_type)
        values (i, concat('branch_', i), 1000.00, 'Checking');
        set i = i + 1;
    end while;
end $$
delimiter ;

call populate_accounts(5000);

-- Computer couldn't handle any of these :(
-- call populate_accounts(50000);
-- call populate_accounts(100000);
-- call populate_accounts(150000);

-- *** Problem 3 ***

create index index_branch_name on accounts (branch_name);
create index index_account_type on accounts (account_type);
create index index_account_type_balance on accounts (account_type, balance);

-- *** Problem 4 ***
-- A bit tricky, since all branches are unique and all balances the same - see problem 2 code

select count(*) from accounts where balance = 1000.00;
select count(*) from accounts where balance between 500.00 and 25000.00;

-- *** Problems 5, 6, 7, and 8 ***
-- Limited to 5,000 rows (see above)

delimiter $$
create procedure measure_avg_execution_time(query_text varchar(1000))
begin
    declare start_time datetime;
    declare end_time datetime;
    declare total_time bigint;
    declare avg_time bigint;
    declare i int;

    set i = 1;
    set total_time = 0;

    -- Execute the query 10 times
    while i <= 10 do
        set start_time = now();
        set @dynamic_query = query_text; -- Apparently this is a MySQL thing?
        prepare stmt from @dynamic_query;
        execute stmt;
        deallocate prepare stmt;
        set end_time = now();
        
        -- Calculate execution time and add to total
        set total_time = total_time + TIMESTAMPDIFF(MICROSECOND, start_time, end_time); -- From Dr. F instructions
        set i = i + 1;
    end while;

    -- Return average execution time and total execution time
    set avg_time = total_time / 10;
    select avg_time, total_time;
end $$
delimiter ;

-- With indexing
call measure_avg_execution_time('select count(*) from accounts where account_type = "Checking" and balance = 1000.00;');
call measure_avg_execution_time('select count(*) from accounts where branch_name = "branch_1" and balance = 1000.00;');
call measure_avg_execution_time('select count(*) from accounts where account_type = "Checking" and balance between 500.00 and 2500.00;');
call measure_avg_execution_time('select count(*) from accounts where branch_name = "branch_1" and balance between 500.00 and 2500.00;');

-- Without indexing
alter table accounts drop index index_branch_name;
alter table accounts drop index index_account_type;
alter table accounts drop index index_account_type_balance;
call measure_avg_execution_time('select count(*) from accounts where account_type = "Checking" and balance = 1000.00;');
call measure_avg_execution_time('select count(*) from accounts where branch_name = "branch_1" and balance = 1000.00;');
call measure_avg_execution_time('select count(*) from accounts where account_type = "Checking" and balance between 500.00 and 2500.00;');
call measure_avg_execution_time('select count(*) from accounts where branch_name = "branch_1" and balance between 500.00 and 2500.00;');