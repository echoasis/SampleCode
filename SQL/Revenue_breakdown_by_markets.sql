(select concat('Week ',week(session_time)) as week_num, 'LA' as marketing_group, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(session_time) as wn

from appointment_requests ar
join (select id, name from cities) as c
on c.id=ar.city_id

where ar.status='completed' and session_time>=now()-interval 1 year
and c.name in ('Los Angeles')
group by week_num)

union all
(select concat('Week ',week(session_time)) as week_num, 'BAY' as marketing_group, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(session_time) as wn
  
 from appointment_requests ar
join (select id, name from cities) as c
on c.id=ar.city_id

where ar.status='completed' and session_time>=now()-interval 1 year
and c.name in ('Silicon Valley','San Francisco','Oakland/East Bay')
group by week_num
  )

union all
(select concat('Week ',week(session_time)) as week_num, 'NY' as marketing_group, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(session_time) as wn
  
 from appointment_requests ar
join (select id, name from cities) as c
on c.id=ar.city_id

where ar.status='completed' and session_time>=now()-interval 1 year
and c.name in ('NYC','Northern New Jersey','NYC - Queens','NYC - The Bronx','NYC - Staten Island','Long Island/The Hamptons','NYC - Westchester County')
group by week_num
  )

union all
(select concat('Week ',week(session_time)) as week_num, 'TX' as marketing_group, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(session_time) as wn
  
 from appointment_requests ar
join (select id, name from cities) as c
on c.id=ar.city_id

where ar.status='completed' and session_time>=now()-interval 1 year
and c.name in ('Austin','Dallas','Houston','San Antonio')
group by week_num
  )

union all
(select concat('Week ',week(session_time)) as week_num, 'CA' as marketing_group, sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue,week(session_time) as wn
  
 from appointment_requests ar
join (select id, name from cities) as c
on c.id=ar.city_id

where ar.status='completed' and session_time>=now()-interval 1 year
and c.name in ('Orange County','San Diego','Inland Empire','Napa/Sonoma County','Santa Barbara','Palm Springs','Sacramento','Temecula')
group by week_num
  )

order by marketing_group,wn