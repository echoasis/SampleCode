set @csum:=0, @past:=0;

select *
from (

select j.date as Date, j.count as Engaged, ifnull(tx.In_Network,@past) as Available
from (
select DATE_FORMAT(a.session_time,'%Y-%m') as date, count(distinct(a.therapist_id)) as count 
  from appointments a 
  
  left join appointment_requests ar
  on a.appointment_request_id = ar.id
  
  left join (
  select c.id,c.name
  from cities c) as n 
  on ar.city_id=n.id
  where n.name='Los Angeles' and (a.status='complete' or a.status='reviewed')
  group by date


) as j
  
  left join
  (select tx.date, tx.therapist_cnt, (@csum := @csum + tx.therapist_cnt) as In_Network
   
   from (
   select DATE_FORMAT(u.created_at,'%Y-%m') as date, count(distinct(u.id)) as therapist_cnt
     from users as u
     left join (select therapist_id
                from appointments
   ) as a
  on a.therapist_id=u.id
  where u.kind = 'therapist' and u.city = 'Los Angeles' and suspended<>1
group by date
  ) as tx
   
  
  ) tx
  on tx.date=j.date) a

where date >= DATE_FORMAT((last_day(now()) + interval 1 day - interval 4 month),'%Y-%m')