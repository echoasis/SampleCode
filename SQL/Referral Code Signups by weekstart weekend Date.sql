select 
concat(b.date, ' to ', b.date+interval 6 day) as week,
sum(df.num_sign_up) as num_sign_up

#num_book,
#revenue

from

(select date, week(date,1) as week
from (
    select curdate() - INTERVAL (a.a + (10 * b.a) + (100 * c.a)) DAY as Date
    from (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as a
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as b
    cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as c

order by Date) a
where a.Date >'2016-12-16'
group by week) b

left join
(select promo_code,
week(created_at) as week_num,
count(*) as num_sign_up

from users u
where 1=1
and u.created_at>=now()-interval 12 month
and promo_code in
(
  select invite_code
  from users u
  where u.kind='client'
  group by invite_code
 )
group by week(created_at),promo_code
order by week(created_at),promo_code) df
on b.week=df.week_num

left join

(select
u.promo_code,
week(u.created_at) week_num,
count(distinct(ar.user_id)) num_ft_book

from appointment_requests ar

join users u
on u.id=ar.user_id

where 1=1
and ar.status in ('completed')
and u.created_at>=now()-interval 12 month
and promo_code in
(
  select invite_code
  from users u
  where u.kind='client'
  group by invite_code
 )
group by week(u.created_at),promo_code
order by week(u.created_at),promo_code) df1


on df.promo_code=df1.promo_code
and df.week_num=df1.week_num



group by b.week
order by b.week