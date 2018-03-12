select channel2,converge_day, sum(revenue) as revenue, count(*) as number_session from
(select ft.client_id, TIMESTAMPDIFF(hour, ft.create_day, ft.session_time) as converge_day,sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue
  from
(select ar.user_id as client_id,  ar.session_time, u.created_at as create_day,ar.session_total_price, ar.gift_amount, ar.sale_tax
 from users u
 join appointment_requests ar
 on ar.user_id=u.id
 where ar.status='completed' 
   ) ft
 where TIMESTAMPDIFF(hour, ft.create_day, ft.session_time)>=0 and TIMESTAMPDIFF(hour, ft.create_day, ft.session_time)<=72
group by client_id, converge_day) b

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
 
    u.id ,u.created_at
   from users u
   left join attributions a
   on u.attribution_id = a.id
   where u.kind='client' 
group by u.id) a
on a.id=b.client_id
 
where converge_day>=0 and converge_day<=72
 group by channel2, converge_day