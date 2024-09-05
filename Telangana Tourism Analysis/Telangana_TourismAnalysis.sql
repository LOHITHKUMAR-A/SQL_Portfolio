
/*
--Create Database Project_Telanganause Project_Telangana;
SELECT * FROM [dbo].[domestic_visitors]
-- SQL SERVER  ONLY 1 DATATYPE  change
ALTER TABLE  [dbo].[domestic_visitors]ALTER COLUMN visitors INT;
ALTER TABLE  [dbo].[domestic_visitors]
ALTER COLUMN DATE DATE;

ALTER TABLE  [dbo].[foreign_visitors]
--ALTER COLUMN DATE DATE;
ALTER COLUMN VISITORS INT;
*/

/*
1.	List down the top 10 districts that have the highest number of domestic visitors overall (2016 - 2019)?
(Insight: Get an overview of districts that are doing well)
*/

WITH CTE AS(
SELECT district,sum(visitors)  Total_visitors,DENSE_RANK()  OVER(ORDER BY sum(visitors) DESC ) R
FROM [dbo].[domestic_visitors]GROUP BY district
)SELECT * FROM CTE WHERE R<=10;


/*2.	List down the top 3 districts based on compounded annual growth rate (CAGR) of visitors between (2016 - 2019)?
(Insight: Districts that are growing)
*/

--Domestic

WITH CTE AS (
    SELECT DISTRICT,year,SUM(visitors) AS visitors
    FROM [dbo].[domestic_visitors]
    WHERE year IN ('2016', '2019')
    GROUP BY DISTRICT, year
),
CTE2 AS (
    SELECT District,
        MAX(CASE WHEN year = 2016 THEN visitors END) AS Initialvalue,
        MAX(CASE WHEN year = 2019 THEN visitors END) AS Finalvalue,
        CASE WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                        MAX(CASE WHEN year = 2016 THEN visitors END)), 1.0 / 3 ) - 1, 4) ELSE 0 END AS CAGR,
        DENSE_RANK() OVER (ORDER BY  CASE 
                WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                    ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                            MAX(CASE WHEN year = 2016 THEN visitors END)),  1.0 / 3 ) - 1, 4) ELSE 0  END DESC) AS R
    FROM CTE  
    GROUP BY district
)
SELECT * FROM CTE2 
WHERE R <= 3;


--Foreign
WITH CTE AS (
    SELECT DISTRICT,year,SUM(visitors) AS visitors
    FROM [dbo].[foreign_visitors]
    WHERE year IN ('2016', '2019')
    GROUP BY DISTRICT, year
),
CTE2 AS (
    SELECT District,
        MAX(CASE WHEN year = 2016 THEN visitors END) AS Initialvalue,
        MAX(CASE WHEN year = 2019 THEN visitors END) AS Finalvalue,
        CASE WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                        MAX(CASE WHEN year = 2016 THEN visitors END)), 1.0 / 3 ) - 1, 4) ELSE 0 END AS CAGR,
        DENSE_RANK() OVER (ORDER BY  CASE 
                WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                    ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                            MAX(CASE WHEN year = 2016 THEN visitors END)),  1.0 / 3 ) - 1, 4) ELSE 0  END DESC) AS R
    FROM CTE  
    GROUP BY district
)
SELECT * FROM CTE2 
WHERE R <= 3;

/*
3.	List down the bottom 3 districts based on compounded annual growth rate (CAGR) of visitors between (2016 - 2019)?
(Insight: Districts that are declining)
*/
--Domestic
DROP  TABLE IF EXISTS dbo.CAGR_D
SELECT * INTO dbo.CAGR_D FROM 
   ( SELECT District,
        MAX(CASE WHEN year = 2016 THEN visitors END) AS Initialvalue,
        MAX(CASE WHEN year = 2019 THEN visitors END) AS Finalvalue,
        CASE WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                        MAX(CASE WHEN year = 2016 THEN visitors END)), 1.0 / 3 ) - 1, 4) ELSE 0 END AS CAGR,
        DENSE_RANK() OVER (ORDER BY  CASE 
                WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                    ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                            MAX(CASE WHEN year = 2016 THEN visitors END)),  1.0 / 3 ) - 1, 4) ELSE 0  END ASC) AS R
    FROM
	(SELECT DISTRICT,year,SUM(visitors) AS visitors
    FROM [dbo].[domestic_visitors]
    WHERE year IN ('2016', '2019')
    GROUP BY DISTRICT, year)
	CTE_CAGR 
 GROUP BY district) CTE_CAGR2

SELECT * FROM dbo.CAGR_D WHERE R <= 3;



--Foreign
DROP  TABLE IF EXISTS dbo.CAGR_F
SELECT * INTO dbo.CAGR_F FROM 
   ( SELECT District,
        MAX(CASE WHEN year = 2016 THEN visitors END) AS Initialvalue,
        MAX(CASE WHEN year = 2019 THEN visitors END) AS Finalvalue,
        CASE WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                        MAX(CASE WHEN year = 2016 THEN visitors END)), 1.0 / 3 ) - 1, 4) ELSE 0 END AS CAGR,
        DENSE_RANK() OVER (ORDER BY  CASE 
                WHEN MAX(CASE WHEN year = 2016 THEN visitors END) > 0 THEN 
                    ROUND(POWER((CAST(MAX(CASE WHEN year = 2019 THEN visitors END) AS FLOAT) / 
                            MAX(CASE WHEN year = 2016 THEN visitors END)),  1.0 / 3 ) - 1, 4) ELSE 0  END ASC) AS R
    FROM
	(SELECT DISTRICT,year,SUM(visitors) AS visitors
    FROM [dbo].[foreign_visitors]
    WHERE year IN ('2016', '2019')
    GROUP BY DISTRICT, year)
	CTE_CAGR 
 GROUP BY district) CTE_CAGR2

SELECT * FROM dbo.CAGR_F WHERE R <= 3;



/*4.	What are the peak and low season months for Hyderabad based on the data from 2016 to 2019 for Hyderabad district?
(Insight: Government can plan well for the peak seasons and boost low seasons by introducing new events)
*/

Select district,month,
Case when R=1 then 'Peak Month' 
     when R=12 then 'Low Month' Else '' End As MonthType,Total_Visitors
	 From
(
SElect V1.district,v1.month,sum(v1.visitors+v2.visitors) Total_Visitors,
DENSE_RANK() over( order by sum(v1.visitors+v2.visitors) desc) R
from 
[dbo].[domestic_visitors] V1
Join [dbo].[foreign_visitors] V2 ON V1.district=V2.district AND V1.date=V2.date
WHERE V1.district='Hyderabad'
GROUP BY V1.district,v1.month
) As R
where R in ('1','12');







/*5.	Show the top & bottom 3 districts with high domestic to foreign tourist ratio?
(Insight: Government can learn from top districts and replicate the same to bottom districts which can improve the foreign visitors 
as foreign visitors will bring more revenue)
*/

SELECT  V1.district, SUM(V1.visitors) V,SUM(V2.visitors) VV,Case when SUM(V2.visitors)> 0 then 
ROUND(CAST(SUM(V1.visitors) AS FLOAT)/SUM(V2.visitors),2) ELSE 0 END AS Ratio,
DENSE_RANK() OVER(ORDER BY Case when SUM(V2.visitors)> 0 then ROUND(CAST(SUM(V1.visitors) AS FLOAT)/SUM(V2.visitors),2) ELSE 0 END DESC) AS R
from 
[dbo].[domestic_visitors] V1
Join [dbo].[foreign_visitors] V2 ON V1.district=V2.district AND V1.date=V2.date
--WHERE V1.district='Adilabad'
GROUP BY V1.district;




/*

CREATE TABLE dbo.population(
District varchar(50) NULL,
Population int null
);
Select * from dbo.population

UPDATE dbo.population SET District='Warangal (Rural)' where  District='Warangal Rural' ;
UPDATE dbo.population SET District='Warangal (Urban)' where  District='Warangal Urban' ;

6.	List the top & bottom 5 districts based on ‘population to tourist footfall ratio*’ ratio in 2019?
( ” ratio: Total Visitors / Total Residents Population in the given year)
(Insight: Find the bottom districts and create a plan to accommodate more tourists)

*/
WITH CTE AS(
Select V1.district,V1.year,SUM(v1.visitors+v2.visitors) TotalVisitors--,Sum(P.population) Total_population
from 
[dbo].[domestic_visitors] V1
Join [dbo].[foreign_visitors] V2 ON V1.district=V2.district AND V1.date=V2.date
WHERE V1.year=2019
GROUP BY V1.district,V1.year
)
,CTE2 AS (
SELECT CASE 
WHEN district='Yadadri Bhuvanagiri' THEN 'Yadadri Bhongir'
WHEN district='Medchal–Malkajgiri' THEN 'Medchal '
WHEN district='Mahabubnagar' THEN 'Mahbubnagar'
WHEN district='Komaram Bheem' THEN 'Komaram Bheem Asifabad'
WHEN district='Jayashankar Bhupalpally' THEN 'Jayashankar Bhoopalpally'
WHEN district='Jagitial' THEN 'Jagtial '
ELSE District END AS District,
population
FROM  dbo.population
)
SELECT CTE.District,CTE.TotalVisitors ,CTE2.Population, ROUND(CAST(CTE.TotalVisitors AS FLOAT)/CTE2.Population,2) AS FootFall_Ratio
FROM CTE2
FULL OUTER JOIN CTE  ON CTE2.district=CTE.district 
ORDER BY FootFall_Ratio DESC;




/*
7.	What will be the projected number of domestic and foreign tourists in Hyderabad in
2025 based on the growth rate from previous years?

(Insight: Better estimate of incoming tourists count so that government can plan the infrastructure better)
*/
SELECT CEILING(Initialvalue*POWER((1+(CAGR)),9)) as V2025_D FROM dbo.CAGR_D
WHERE district='Hyderabad';

SELECT CEILING(Initialvalue*POWER((1+(CAGR)),9)) as V2025_F FROM dbo.CAGR_F
WHERE district='Hyderabad';



/*
8.	Estimate the projected revenue for Hyderabad in 2025 based on average spend per tourist (approximate data)
*/

--Assuming 1250 as average spent per person for domestic and 1800 for forigner
SELECT CEILING(Initialvalue*POWER((1+(CAGR)),9))*1250 as Revenue_Domestic FROM dbo.CAGR_D
WHERE district='Hyderabad';

SELECT CEILING(Initialvalue*POWER((1+(CAGR)),9))*1800 as Revenue_Foreign FROM dbo.CAGR_F
WHERE district='Hyderabad';



