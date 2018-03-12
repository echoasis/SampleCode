set @w=-1;

select concat(b.date,'-',b.date+interval 6 day) as week, sum(completed)/sum(request) as fill_rate, b.wn
from
(select a.*, floor((@w:=@w+1)/7) as wn
from

(select date(convert_tz(session_time,'UTC',timezone)) as date, sum(case when status not in ('cancelled') then 1 else 0 end)/count(*) as fill_rate, sum(case when status not in ('cancelled') then 1 else 0 end) as completed, count(*) as request 
from appointment_requests ar 
where (ar.status ='completed'  or (ar.status='cancelled' and is_unfilled is true)) and date(convert_tz(session_time,'UTC',timezone))>=date(now()-interval  (dayofyear(now())-1) day -interval weekday(now()-interval  (dayofyear(now())-1) day) day) and session_time<=now()
group by date) a) b

group by wn