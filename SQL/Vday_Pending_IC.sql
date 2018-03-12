select x1.Appointment_request_id, x1.Date, x1.start_time, x1.city,x1.Client_Name,x1.MT1, x1.MT1_number,if(x2.MT2=x1.MT1, NULL, x2.MT2) as MT2, if(x2.MT2_number=x1.MT1_number,NULL,x2.MT2_number) as MT2_number,df2.comment_VDAY, df2.stamp_time
from

(select * from
(select ar.Appointment_request_id, concat(ar.customer_first_name,' ', ar.customer_last_name) as Client_Name, concat(u.first_name,' ', u.last_name) as MT1, a.therapist_id,u.mobile_number as MT1_number,  date(convert_tz(ar.session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) as Date, convert_tz(ar.session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end) as start_time, c.name as city
from
(select Appointment_request_id, city_id, session_time, timezone, customer_first_name, customer_last_name from

(select Appointment_request_id, sum(instant) as instant, city_id, session_time, timezone, customer_first_name, customer_last_name from

(select ar.id as Appointment_request_id, a.id, if(a.instant_availability_id is not null, 1,0) as instant, ar.city_id, ar.session_time, timezone, ar.customer_first_name, ar.customer_last_name
from appointment_requests ar
join appointments a
on ar.id=a.Appointment_request_id


where ar.session_time>=now() and ar.session_time<='2018-02-18' and (ar.status='pending' or ar.status='filled') and ar.appointment_type='couples' and a.status='scheduled' ) x

group by Appointment_request_id) a
where instant<>0) ar
join appointments a
on ar.Appointment_request_id=a.Appointment_request_id
 join cities c
 on c.id=ar.city_id
join users u
on u.id=a.therapist_id
where a.status='scheduled' and ar.Appointment_request_id not in 
(select e.ApptID from
   (select d.ApptID, d.comment from

(select ac.Appointment_request_id as ApptID, ac.comment
 from appointment_comments ac
 
order by ac.created_at desc) d
group by d.ApptID) e
 where e.comment like '%VDAY Confirmed%') and u.is_test=0
order by therapist_id) df1
group by df1.Appointment_request_id) x1

join (select df1.Appointment_request_id, concat(u.first_name,' ', u.last_name) as MT2, u.mobile_number as MT2_number from
(select * from
(select ar.id as Appointment_request_id, a.therapist_id, a.status
from appointment_requests ar
join appointments a
on ar.id=a.Appointment_request_id
 
) b

where 1=1
and b.status='scheduled'
order by b.therapist_id desc) df1
 join users u
 on u.id=df1.therapist_id
 where u.is_test=0
group by Appointment_request_id) x2
on x2.Appointment_request_id=x1.Appointment_request_id

left join
(select df2.* from
(select c.* from
  (select ar.id as ApptID, ac.comment as comment_VDAY, ac.created_at as stamp_time
 from appointment_requests ar
 left join appointment_comments ac
 on ar.id=ac.Appointment_request_id
  order by ac.created_at desc) c
group by c.ApptID) df2
where df2.comment_VDAY like '%VDAY Pending%') df2
on df2.ApptID=x1.Appointment_request_id