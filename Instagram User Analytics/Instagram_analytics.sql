

/**
--Find the 5 oldest users of the Instagram from the database provided

SELECT
username,
created_at
from
ig_clone.users
ORDER BY created_at
LIMIT 5


--Find the users who have never posted a single photo on Instagram

SELECT
u.username 
FROM
ig_clone.users u 
LEFT JOIN ig_clone.photos p
ON u.id=p.user_id
WHERE p.user_id is null
ORDER BY u.username;


--Identify the winner of the contest and provide their details to the team

with base as(
SELECT
u.username, l.photo_id,
count(l.user_id) AS likes
FROM
ig_clone.likes l
inner join ig_clone.photos p
on l.photo_id=p.id
inner join ig_clone.users u
on p.user_id=u.id
GROUP BY l.photo_id,u.username
ORDER BY likes DESC
LIMIT 1)
select username from base;


--Identify and suggest the top 5 most commonly used hashtags on the platform


SELECT
t.tag_name, COUNT(pt.photo_id) as Ctags
FROM
ig_clone.tags t
INNER JOIN ig_clone.photo_tags pt 
ON pt.tag_id=t.id
GROUP BY t.tag_name
ORDER BY Ctags DESC
limit 5

--What day of the week do most users register on? Provide insights on when to schedule an ad campaign
Answer:- HERE, days count start from Monday-0, Tuesday-1,……,Sunday-6 .Hence,Thursday and Sunday are good for ad campaign.

SELECT
WEEKDAY(created_at),
COUNT(username) as num_users
FROM
ig_clone.users
GROUP BY WEEKDAY(created_at)
order by num_users DESC


--User Engagement: 
Are users still as active and post on Instagram or they are making fewer posts.
Your Task: Provide how many times does average user posts on Instagram. 
Also, provide the total number of photos on Instagram/total number of users.

--Posted photos

SELECT sum(photosid) as t_photos,
count(usersid) as t_users,
SUM(photosid)/COUNT(usersid) as photos_per_user
FROM(
SELECT
u.id AS usersid, COUNT(p.id) AS photosid
FROM
 ig_clone.users u
 LEFT JOIN ig_clone.photos p
ON u.id=p.user_id
 GROUP BY u.id) base
WHERE photosid > 0


--No photos posted

SELECT sum(photosid) as t_photos,
count(usersid) as t_users,
SUM(photosid)/COUNT(usersid) as photos_per_user
FROM(
SELECT
u.id AS usersid, COUNT(p.id) AS photosid
FROM
 ig_clone.users u
 LEFT JOIN ig_clone.photos p
ON u.id=p.user_id
 GROUP BY u.id) base
 
 
--Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this)

 
 WITH pcount AS 
 (SELECT
user_id, COUNT(photo_id) AS n_like
FROM
ig_clone.likes
GROUP BY
user_id
ORDER BY
n_like DESC
) SELECT *
FROM Pcount 
WHERE n_like=(SELECT COUNT(*) FROM ig_clone.photos)

**/
 
