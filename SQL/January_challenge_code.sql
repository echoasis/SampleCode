select x.user_id,x.User_name,x.purchase_time, x.num_package_purchased, x.money_spent, x.post_purchase_num_session, x.session_length as post_purchase_total_minute, s.num_session_all_time, x.rank, date(u.created_at) as user_signup_time from
(select b.user_id, b.User_name,b.purchase_time, b.num_package_purchased, b.money_spent,count(*) as post_purchase_num_session, b.rank, sum(b.session_length) as session_length from
(select a.user_id, date(a.purchase_time) as purchase_time,ar.created_at, ar.session_length, concat(ar.customer_first_name, ' ', ar.customer_last_name) as User_name, ar.customer_mobile as phone_number, c.name as city, us.status as rank, a.num_package_purchased, a.money_spent from

(select p.client_id as user_id, pp.title, min(p.created_at) as purchase_time, count(*) as num_package_purchased, sum(b.amount/100) as money_spent
from packages p
join billings b on b.package_id=p.id


join package_pricings pp
on p.package_pricing_id=pp.id

join users u
on u.id=p.client_id

where b.status='captured'
and u.is_test=0
and pp.title='10 hour package' 
 
 and p.created_at>='2018-01-05 00:00:00'
 and p.created_at<'2018-02-01 00:00:00'
 
 
group by p.client_id) a

join appointment_requests ar
on a.user_id=ar.user_id and ar.created_at>=a.purchase_time
 join cities c
 on ar.city_id=c.id
 left join user_scores us
 on us.user_id=ar.user_id
where ar.status='completed' and us.user_score_type_id=4 ) b
group by b.user_id) x 

join users u
on x.user_id=u.id
join
(select user_id, count(*) as num_session_all_time from
 appointment_requests ar
  where ar.status='completed'
 group by user_id
  ) s
on s.user_id=x.user_id