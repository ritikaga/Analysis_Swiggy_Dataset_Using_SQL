select * from dbo.[Restaurant Data];
select cost from [Restaurant Data]where cost like 'NA%';
select * from [Restaurant Data] where rating=4;

/* As Data is very messy we clean the data */
 --Start Cleaning 

 -- NULL Value Handling
 select name from [Restaurant Data] where  [lic_no] is null or [rating] is null or [rating_count] is null ;
 delete from [Restaurant Data] where [lic_no] is null or [rating] is null or [rating_count] is null ;
 delete  from [Restaurant Data] where cost like 'NA%';
 delete  from [Restaurant Data] where cuisine like 'NA%';

 -- check how many types of cuisnes 
 select distinct[cuisine] from [Restaurant Data] 

 -- Check Duplicate values
 select distinct [city] from [Restaurant Data];
 --There is no Duplicate data
 

 -- Replace the text data with numeric data
 --1.replace rating count with numeric data
 update [Restaurant Data]
 set rating_count =replace(
                      replace(
                     replace(
                      replace(rating_count, '+', ''), 
                        'K', '000'), 
                      'Too Few Ratings', '0'), 
                    'ratings', '');
--2. replace rupee sign to space
update [Restaurant Data]
set cost=replace(cost,NCHAR(8377),'');

-- 3.replace -- to 0
update  [Restaurant Data]
set rating = replace(rating, '--', '0');


 --Change the datatype
 --1.Converting ‘rating_count’ column datatype in ‘int’
alter table [Restaurant Data]
alter column rating_count INT;

----2.Converting ‘rating’ column datatype in ‘float’
alter table [Restaurant Data]
alter column cost INT;

--3.Converting ‘rating’ column datatype in ‘float’
alter table [Restaurant Data]
alter column rating float;


--Answering Questions From Dataset

--1.What are the most Popular Cuisines served throughout the dataset ?


select top 10 trim(value) as  Popular_cuisine, count(*) AS Cuisine_count
from [Restaurant Data]
cross apply string_split (cuisine,',')
group by trim (value)
order by count(*) desc;


--2.What are the top 5 most popular restaurant chains in India in terms of ratings given? 
--   Taking only those rating_count that are equal to or greater than 100.

select top 5 name, avg(rating) as Avg_rating
from [Restaurant Data]
where rating_count>=100
group by name 
order by Avg_rating desc;


--3. Which are those Restaurants that has maximum number of branches ?

select top 10 name, count(city) as No_of_Branch
from [Restaurant Data]
group by name
order by count(city) desc;


--4. What are the top 10 cities as per the number of restaurants listed?

select top 10 city,count(name) as Restaurants_numbers
 from [Restaurant Data]
 group by city
 order by Restaurants_numbers desc;

--5. What are the Top 5 most popular restaurant chains in India?

select top 5 name as Popular_restaurant,avg(rating) as Average_rating
from [Restaurant Data]
group by name
order by Average_rating desc;

--6.Which city is having the least expensive restaurant in terms of cost?
Select top 1 city from [Restaurant Data]
group by city
order by min(cost) asc;

--7.Number of cities (including subregions) where swiggy is having their restaurants listed? 

select  count (distinct(city)) as Total_Cities from [Restaurant Data];

--8. Restaurant chain with maximum number of branches?
select top 1 name from [Restaurant Data]
group by name
order by count(name) desc;

