select x.*, ifnull(w.num_referred,0) as num_referred
from
(select c.user_id, c.total_sessions,c.rank, c.city, c.no_discount_sessions from
(select a.*, ifnull(b.no_discount_sessions,0) as no_discount_sessions
from
(select ar.user_id, count(*) as total_sessions, us.status as rank, c.name as city
from appointment_requests ar
 left join user_scores us
 on us.user_id=ar.user_id
 join cities c
 on c.id=ar.city_id
 left join users u
 on u.id=ar.user_id
where ar.status='completed' and us.user_score_type_id=4 and u.is_test=0
group by user_id) a

left join
(select user_id, count(*) as no_discount_sessions
 from appointment_requests ar
 where ar.status='completed' and ifnull(ar.credit_amount,0)=0 and ifnull(ar.minutes_amount,0)=0 and ifnull(ar.discount_amount,0)=0
  group by user_id
  ) b
on a.user_id=b.user_id) c
where c.no_discount_sessions=0) x

left join 
(select b.user_id, count(distinct(code_user)) as num_referred
from
(select u.id as user_id, a.code_user, a.id, invite_code, a.promo_code
from users u
join 
(select ar.id, ar.user_id as code_user, u.promo_code from appointment_requests ar
left join users u
on ar.user_id=u.id
where ar.status='completed') a
on a.promo_code=u.invite_code
 
) b
group by b.user_id
  ) w
on w.user_id=x.user_id