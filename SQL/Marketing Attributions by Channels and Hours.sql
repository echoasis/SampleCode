(select c.channel2,'=0' as bucket, 0_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day=0) then 1 else 0 end) as 0_hour


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

(select c.channel2,'<=6' as bucket, within_6_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=6) then 1 else 0 end) as within_6_hour


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
(select c.channel2,'<=12' as bucket, within_12_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=12) then 1 else 0 end) as within_12_hour


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
(select c.channel2,'<=18' as bucket, within_18_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=18) then 1 else 0 end) as within_18_hour


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
(select c.channel2,'<=24' as bucket, within_24_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=24) then 1 else 0 end) as within_24_hour


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
(select c.channel2,'<=30' as bucket, within_30_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=30) then 1 else 0 end) as within_30_hour


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
(select c.channel2,'<=36' as bucket, within_36_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=36) then 1 else 0 end) as within_36_hour


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
(select c.channel2,'<=48' as bucket, within_48_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=48) then 1 else 0 end) as within_48_hour


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
(select c.channel2,'<=60' as bucket, within_60_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=60) then 1 else 0 end) as within_60_hour


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
(select c.channel2,'<=72' as bucket, within_72_hour/number_sign_up as ratio
from

(select channel2, 
 sum(case when (cd.converge_day>=0 and cd.converge_day <=72) then 1 else 0 end) as within_72_hour


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
order by field(bucket,'=0','<=6','<=12','<=18','<=24','<=30', '<=36','<=48','<=60', '<=72')