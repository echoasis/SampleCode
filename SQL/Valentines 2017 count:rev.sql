(select 'requested' as appt_status,count(*) as requested, sum(session_price) as revenue
from appointment_requests ar
where date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-02-14') and (ar.status='completed' or (ar.status='cancelled' and ar.is_unfilled=1)))

union all
(select 'completed' as appt_status,count(*) as completed, sum(ar.session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue
 from appointment_requests ar
 where date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-02-14') and ar.status='completed'
  
  )