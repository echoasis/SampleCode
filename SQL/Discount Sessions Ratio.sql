select a.*, ifnull(b.no_discount_sessions,0) as no_discount_sessions, ifnull(no_discount_sessions/total_sessions,0) as ratio
from
(select user_id, count(*) as total_sessions
from appointment_requests ar
where ar.status='completed'
group by user_id) a

left join
(select user_id, count(*) as no_discount_sessions
 from appointment_requests ar
 where ar.status='completed' and ifnull(ar.credit_amount,0)=0 and ifnull(ar.minutes_amount,0)=0 and ifnull(ar.discount_amount,0)=0
  group by user_id
  ) b
on a.user_id=b.user_id