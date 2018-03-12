select c.channel2, b.converge_day as hour_to_converge, number_booking, c.number_sign_up, number_booking/c.number_sign_up as ratio

from

(select channel2, converge_day,
 count(*) as number_booking

from

( SELECT
  
   CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
  WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'
   WHEN source = 'Organic' then 'Organic'
 ELSE 'Other' END as channel2,
 
    u.id ,u.created_at
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' 
group by u.id) a
  join
 (select ft.client_id, TIMESTAMPDIFF(hour, ft.create_day, ft.first_time) as converge_day
  from
(select ar.user_id as client_id,  min(ar.session_time) as first_time, u.created_at as create_day
 from users u
 join appointment_requests ar
 on ar.user_id=u.id
 where ar.status='completed'
 group by client_id 
   ) ft
 group by client_id) cd
on cd.client_id=a.id
group by channel2, converge_day) b
 
 join 
 ( SELECT
  
   CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
  WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'
   WHEN source = 'Organic' then 'Organic'
 ELSE 'Other' END as channel2,
 
    count(*) as number_sign_up
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' 
group by channel2) c
on c.channel2=b.channel2
where b.converge_day>=0 and b.converge_day<=72
order by channel2, hour_to_converge