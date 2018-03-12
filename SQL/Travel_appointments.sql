select oc.origin_city,sum(case when c.name<>oc.origin_city then 1 else 0 end) as number_travel, count(*), sum(case when c.name<>oc.origin_city then 1 else 0 end)/count(*) as ratio
from appointment_requests ar
join cities c
on c.id=ar.city_id
join
  (select user_id,city as origin_city from 
   (select user_id,count(*) as cnt,c.name as city from appointment_requests ar join cities c on c.id=ar.city_id where status='completed' group by user_id,city order by cnt desc)a 
   group by user_id) oc
on oc.user_id=ar.user_id

where ar.status='completed'
group by oc.origin_city