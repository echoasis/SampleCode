select x.city, x.repeat_appointments, y.repeat_client
from

(select sum(isrepeat) as repeat_appointments,
 city
from
(select  ar.id,
case when ar.session_time>ft.first then 1 else 0 end as isrepeat, c.name as city
from appointment_requests ar
join cities c
on c.id=ar.city_id
left join 
(select user_id, min(session_time) as first
  
 from appointment_requests ar
   where ar.status='completed'
 
group by user_id) ft
on ft.user_id=ar.user_id

where ar.status in ('completed')

) w
group by city) x

left join
(select s.city, count(*) as repeat_client
 from
  (select user_id, count(*) as book_time, c.name as city
 from appointment_requests ar
 join cities c
 on c.id=ar.city_id
 where ar.status='completed'
 group by user_id) s
  where book_time>1
 group by s.city
  ) y
on y.city=x.city