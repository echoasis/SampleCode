(select c.channel2,'<=3' as bucket, within_3_day/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=3) then 1 else 0 end) as within_3_day


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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
union all
(select c.channel2,'<=7' as bucket, within_7_day/number_sign_up as  ratio
from

(select channel2, 

sum( case when (cd.converge_day >=0 and cd.converge_day <= 7) then 1 else 0 end) as within_7_day

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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
union all
(select c.channel2,'<=14' as bucket, within_14_day/number_sign_up as  ratio
from

(select channel2, 

sum(case when (cd.converge_day >=0 and cd.converge_day <=14) then 1 else 0 end) as within_14_day


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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
union all
(select c.channel2,'<=21' as bucket, within_21_day/number_sign_up as  ratio
from

(select channel2, 

sum(case when (cd.converge_day>=0 and cd.converge_day <= 21) then 1 else 0 end) as within_21_day
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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
union all
(select c.channel2,'<=30' as bucket, within_30_day/number_sign_up as  ratio
from

(select channel2, 
 
sum(case when (cd.converge_day>=0 and cd.converge_day <= 30) then 1 else 0 end) as within_30_day

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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
union all
(select c.channel2,'<=90' as bucket, within_90_day/number_sign_up as  ratio
from

(select channel2, 

sum(case when (cd.converge_day>=0 and cd.converge_day<=90) then 1 else 0 end) as within_90_day

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
 (select ft.client_id, TIMESTAMPDIFF(day, ft.create_day, ft.first_time) as converge_day
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
group by channel2) b
 
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
on c.channel2=b.channel2)
order by field(bucket,'<=3','<=7','<=14','<=21','<=30','<=90')