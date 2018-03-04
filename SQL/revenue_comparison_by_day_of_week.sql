select tw.day_name,tw.revenue as This_week_revenue, lw.revenue as last_week_revenue

from (
select sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue, dayname(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_name, weekday(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_of_week 

from appointment_requests ar 
where ar.status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>=date(CONVERT_TZ(now(),'UTC','US/Pacific')-interval weekday(CONVERT_TZ(now(),'UTC','US/Pacific')) day)
and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<date(CONVERT_TZ(now(),'UTC','US/Pacific'))
  group by day_name
) as tw
join 
(select sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue, dayname(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_name, weekday(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_of_week 
 
 from appointment_requests ar
 where ar.status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>=date(CONVERT_TZ(now(),'UTC','US/Pacific')-interval weekday(CONVERT_TZ(now(),'UTC','US/Pacific')) day-interval 1 week) and  date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<date(CONVERT_TZ(now()-interval 1 week,'UTC','US/Pacific'))
group by day_name
  
  ) as lw
on lw.day_name=tw.day_name
order by tw.day_of_week