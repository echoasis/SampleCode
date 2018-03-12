select 
case when (a.time_window >=0 and a.time_window <75) then '0-75'
when (a.time_window >=75 and a.time_window <120) then '75-120'
when (a.time_window >=120 and a.time_window <360) then '120-360'
when (a.time_window >=360 and a.time_window <1440) then '360-1440'
when (a.time_window>=1440) then '>=1440'
end as time_w,
time_to_fill from

(select ar.created_at as request_time,a.created_at as app_time,a.session_time,TIMESTAMPDIFF(minute,ar.created_at,a.created_at) as time_to_fill, TIMESTAMPDIFF(minute,ar.created_at,a.session_time) as time_window
from appointment_requests ar
left join appointments a
on ar.id=a.appointment_request_id
where ar.status in ("completed") and a.status in ("complete", "reviewed") and ar.created_at>=now()-interval 1 year) a
having time_w is not null
order by field(time_w, '0-75','75-120','120-360','360-1440','>=1440')