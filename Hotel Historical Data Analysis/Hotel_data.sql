/**Problem statement:- Develop a database to analyse and visualize Hotel Booking Data.

Is the hotel revenue growing by year?
Should the client increase the parking lot size?
What are trends can be seen in data?

**/


with hotels as (
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$'])

/** select
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from hotels
group by arrival_date_year,hotel
**/


select * from hotels
left join dbo.market_segment$
on hotels.market_segment=market_segment$.market_segment
left join dbo.meal_cost$
on meal_cost$.meal=hotels.meal