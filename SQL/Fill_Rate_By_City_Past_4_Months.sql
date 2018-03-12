select mo, tx.city, sum(case when status not in ('cancelled') then 1 else 0 end)/count(*) as percentage

from (
  select n.name as city, DATE_FORMAT(ar.session_time,'%Y-%m') as mo,
  status 
  from appointment_requests as ar
  left join (
    Select c.id, c.name
    from cities c
    ) as n 
  on n.id = ar.city_id
  
 where (ar.status ='completed'  or (ar.status='cancelled' and is_unfilled is true))
) as tx

where tx.mo >=DATE_FORMAT(last_day(now())+interval 1 day -interval 4 month,'%Y-%m') 

  
group by tx.city,tx.mo