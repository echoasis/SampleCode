select channel2,count(*) as signups, sum(revenue) as revenue, sum(booking) as number_booking, sum(booking)/count(*) as conversion
from

(   select
  
  CASE
   when source like '%instagram%' or '%Instagram%' then 'Instagram'
   WHEN campaign LIKE '%ROI%' then 'Facebook'
   when ( source like '%facebook%' or  source ='fb') then 'Facebook'
  WHEN source like '%google%' then 'Google'
   WHEN source like '%twitter%' then 'Twitter'
   WHEN source like '%yelp%' then 'Yelp'
 ELSE 'Other' END as channel2,
 
    u.id ,u.created_at
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' ) a

join (
  select sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue, user_id, 
  case when user_id is not null then 1 else 0 end as booking
  from appointment_requests ar
  where ar.status='completed' 
  group by user_id
  ) b
  on b.user_id=a.id
  
   where date(convert_tz(created_at,'UTC','US/Pacific'))>=now()-interval 1 week and date(convert_tz(created_at,'UTC','US/Pacific'))<=now()
   group by channel2