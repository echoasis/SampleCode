select c.name as city, 

sum(case when (ar.status in ('cancelled') and is_unfilled=1) then 1 else 0 end) as unfilled, 

avg(case when (ar.status in ('cancelled') and is_unfilled=1) then 1 else 0 end) as unfilled_rate 

from
appointment_requests ar
join cities c
on ar.city_id=c.id

where 1=1
and date((convert_tz(session_time,'UTC',
                 case timezone when 'PacificTime (US & Canada)'
                 then 'America/Los_Angeles'
                 else timezone end)))>=now()-interval 30 day
and hour((convert_tz(session_time,'UTC',
              case timezone when 'Pacific Time (US & Canada)'
              then 'America/Los_Angeles'
              else timezone end))) >=19 
and ((ar.status in ('cancelled') and is_unfilled=1) or (ar.status='completed'))
group by city
order by unfilled desc