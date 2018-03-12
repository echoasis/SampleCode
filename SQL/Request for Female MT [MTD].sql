set @x1 = last_day(now())+ interval 1 day - interval 1 month, @x2 = last_day(now()) ;

select f.hour_local, sum(f.female) as requested
from
(select ar.id,
 
 case timezone
 when 'Europe/London' then 
 hour(CONVERT_TZ(session_time,'UTC','Europe/London'))
 when 'Australia/Sydney' then
hour(CONVERT_TZ(session_time,'UTC','Australia/Sydney'))
when 'America/Chicago' then
hour(CONVERT_TZ(session_time,'UTC','America/Chicago'))
when 'America/New_York' then
hour(CONVERT_TZ(session_time,'UTC','America/New_York'))
when 'America/Phoenix' then
hour(CONVERT_TZ(session_time,'UTC','America/Phoenix'))
when 'America/Los_Angeles' or 'Pacific Time (US & Canada)' then
hour(CONVERT_TZ(session_time,'UTC','America/Los_Angeles') ) end as hour_local,
 
 case appointment_type
 when 'couples' then 
 (case session_gender_double_1 when 'female' then 1 when 'either' then 0.5 else 0 end)+
 (case session_gender_double_2 when 'female' then 1 when 'either' then 0.5 else 0 end) 
 else
 (case session_gender_single when 'female' then 1 when 'either' then 0.5 else 0 end) end as female,
 
 ar.status,
 ar.session_time
 
 from appointment_requests ar
 
 left join 
 (select c.id, c.name
  from cities c) as n
 on n.id=ar.city_id

where ar.session_time >= @x1 and ar.session_time<=@x2
and n.name='Los Angeles'
and (ar.status ='completed' or ar.status ='filled' or (ar.status='cancelled' and is_unfilled is true))
group by ar.id
order by ar.session_time asc) as f
group by hour_local