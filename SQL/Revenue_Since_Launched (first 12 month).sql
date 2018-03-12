set @num_month=0,@city='' ;

select city, revenue,concat('Month ',rank) as month,rank
from
(select city,mo,revenue,(case when @city=city COLLATE utf8mb4_unicode_ci then @num_month:=@num_month+1 else @num_month:=1 end) as rank,@city:=city
from
(select c.name as city, DATE_FORMAT(session_time,'%Y-%m') as mo,sum(ar.session_total_price+ifnull(gift_amount,0)-ifnull(sale_tax,0)) as revenue

from appointment_requests ar
join cities c on c.id=ar.city_id

where ar.status='completed' and session_time< last_day(now())+interval 1 day-interval 1 month
 group by city,mo
order by city,mo)a)a
where city in ('Chicago','Miami','Los Angeles','Melbourne','Sydney') and rank<13
order by rank