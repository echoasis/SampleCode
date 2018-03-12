select signup_week, channel, count(*) as num_signup, sum(booker) as num_booker, avg(days_to_conversion) as average_conversion_days
from

(select u.id, b.first_book,
case when b.first_book is not null then 1
else 0 end as booker, date(u.created_at-interval weekday(u.created_at) day) as signup_week, CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
   
 
   
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
   
   WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'

    WHEN source like '%yelp%' then 'Yelp'
  WHEN source like '%apple%' then 'Apple'
 
   WHEN source = 'Organic' then 'Organic'
 
   ELSE 'Other' END as channel, TIMESTAMPDIFF(day, u.created_at, b.first_book) as days_to_conversion
from
users u
left join 
(select * from
(select ar.user_id, ar.session_time as first_book
 from appointment_requests ar
  where ar.status='completed' 
 order by ar.user_id, session_time asc
 
  ) a
group by user_id) b

on b.user_id=u.id
left join attributions a
   on u.attribution_id = a.id
where u.kind='client' and u.created_at>'2017-01-01') x
group by signup_week, channel