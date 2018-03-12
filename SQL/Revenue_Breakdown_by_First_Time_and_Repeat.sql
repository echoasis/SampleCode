select tw.revenue as This_Week_revenue, lw.revenue as last_week_revenue, tw.First_Not, tw.day_name
from (
  select sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue, dayname(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_name, weekday(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_of_week, 
  (case is_repeat 
  when 1 then "Repeat" else "First Time" end) as "First_Not"
  
  from appointment_requests ar
  where ar.status='completed' and  date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>=date(CONVERT_TZ(now(),'UTC','US/Pacific')-interval weekday(CONVERT_TZ(now(),'UTC','US/Pacific')) day)
and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<date(CONVERT_TZ(now(),'UTC','US/Pacific'))
  group by day_name, First_Not
  ) as tw

join (
  select sum(session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue, dayname(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_name, weekday(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as day_of_week, 
  (case is_repeat 
  when 1 then "Repeat" else "First Time" end) as "First_Not"
  
  from appointment_requests ar
  where ar.status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))>=date(CONVERT_TZ(now(),'UTC','US/Pacific')-interval weekday(CONVERT_TZ(now(),'UTC','US/Pacific')) day-interval 1 week) and  date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<date(CONVERT_TZ(now()-interval 1 week,'UTC','US/Pacific'))
group by day_name, First_Not

  )  as lw
on tw.day_name=lw.day_name and tw.First_Not=lw.First_Not
order by tw.day_of_week