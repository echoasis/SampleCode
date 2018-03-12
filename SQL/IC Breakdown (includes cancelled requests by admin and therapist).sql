select b.date, case when b.status = 'complete' or b.status='reviewed' then 'complete'
else b.status end as IC_status, count(*) from
 (
  
  
 select ar.id, a.instant_availability_id,a.status, date(convert_tz(ar.created_at,'UTC','US/Pacific')) as date
from appointment_requests ar
join appointments a
on ar.id=a.appointment_request_id
 
where a.instant_availability_id is not null  
and date(CONVERT_TZ(a.created_at,'GMT','America/Los_Angeles')) >=(2016) and ar.status='completed'


union all
(select ar.id, a.instant_availability_id,a.status, date(convert_tz(ar.created_at,'UTC','US/Pacific')) as date
from appointment_requests ar
join appointments a
on ar.id=a.appointment_request_id
left join cancel_therapist_off_appointment_occurrences co
on co.appointment_request_id=ar.id
 
where a.instant_availability_id is not null  
and date(CONVERT_TZ(a.created_at,'GMT','America/Los_Angeles')) >=(2016) and initiated_by in ('therapist', 'admin') and ar.status='cancelled' ) 
   ) b
 group by b.date, IC_status
order by b.date