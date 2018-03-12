select cn.MT_ID, cn.client_number, b.one_time_number
from 
(select therapist_id as MT_ID, count(distinct(user_id)) as client_number
 from appointments a
 join users u
 on a.user_id=u.id
 where u.kind='client' and (a.status='reviewed' or a.status='complete') and a.therapist_id is not null
 group by MT_ID
                                     

) cn

join 
(select therapist_id, count(*) as one_time_number
from appointments a
where (a.status='reviewed' or a.status='complete') and a.user_id in

(select user_id
 from
  (select user_id, count(distinct(appointment_request_id)) as appointment_number 
 from appointments a
 where (a.status='reviewed' or a.status='complete')
 group by user_id
 ) b
where b.appointment_number=1 ) 

and therapist_id is not null
group by a.therapist_id
) b
on b.therapist_id=cn.MT_ID
group by cn.MT_ID
limit 10000