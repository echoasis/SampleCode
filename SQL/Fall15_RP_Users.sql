set @c_user='',@rank=0, @period_end='2017-09-23 00:00:00';


select b.user_id, rk.status as rank,rk.at_risk, x.avg_booking_interval, timestampdiff(day,z.last_time,b.session_time) as last_booking_interval
from


(select ar.user_id, ar.session_time
from appointment_requests ar
left join user_scores us
on us.user_id=ar.user_id
left join user_discounts ud on ud.id=ar.user_discount_id and ud.user_id=ar.user_id
left join discounts d on d.id=ud.discount_id
where ar.status  in ('completed') and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-09-23', '2017-09-24','2017-09-25') and ar.is_repeat=1 and d.code='fall15' and us.user_score_type_id=4
 
 order by user_id
) b
join 
(select a.user_id,  
  case when num_completed_requests>=6 and weekly_period<=0 then 'AAA'
  when num_completed_requests>=5 and weekly_period<=2 then 'AA'
  when num_completed_requests>=3 and weekly_period<=4 then 'A'
  when num_completed_requests>=2 and weekly_period<=12 then 'B'
  when num_completed_requests>=1 then 'C' end as status,
  
  case when recency>2*period then 1 else 0 end as at_risk
  from
  (SELECT
  user_id,
  DATEDIFF(@period_end,min(DATE(ar.created_at))) tenure,
  DATEDIFF(@period_end,max(DATE(ar.created_at))) recency,
  count(*) num_requests,
  sum(case when ar.status ='completed' then 1 else 0 end) num_completed_requests,
  sum(is_unfilled) unfilled_apts,
  DATEDIFF(@period_end,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end) as period,
  truncate((DATEDIFF(@period_end,min(DATE(ar.created_at)))/sum(case when ar.status ='completed' then 1 else 0 end))/7,0) as weekly_period
  FROM
  appointment_requests ar
  WHERE (status='completed' OR (status='cancelled' AND is_unfilled=1)) and ar.session_time < @period_end
  group by user_id
  ) a
  
  ) rk
on rk.user_id=b.user_id


left join 

(select user_id, avg(interval_between_bookings) as avg_booking_interval
from

(
select f1.user_id,timestampdiff(day,f1.session_time,f2.session_time) as interval_between_bookings,f1.rank, f1.id, f1.session_time 
 from
 (
 select user_id,rank,session_time, id
 from
 (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time, id
 from
 (select user_id,session_time, id
 
 
 from appointment_requests
 where status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<='2017-09-25' and id not in (select ar.id
from appointment_requests ar
left join user_discounts ud on ud.id=ar.user_discount_id and ud.user_id=ar.user_id
left join discounts d on d.id=ud.discount_id
where ar.status  in ('completed') and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-09-23', '2017-09-24','2017-09-25') and d.code='fall15'
  )
 
 order by user_id,session_time)a)a
)f1
 
 join
  (
  select user_id,rank,session_time, id
 from
 (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time, id
 from
 (select user_id,session_time, id
 
 
 from appointment_requests
 where status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<='2017-09-25' and id not in (select ar.id
from appointment_requests ar
left join user_discounts ud on ud.id=ar.user_discount_id and ud.user_id=ar.user_id
left join discounts d on d.id=ud.discount_id
where ar.status  in ('completed') and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-09-23', '2017-09-24','2017-09-25') and d.code='fall15'
  )
 
 order by user_id,session_time)a)a
)f2 on f1.rank=f2.rank-1 and f1.user_id=f2.user_id


) a
group by user_id



) x
on x.user_id=b.user_id

left join 
(
 select user_id,max(session_time) as last_time
 
 
 from appointment_requests ar
 where status='completed' and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end))<='2017-09-25'
  and ar.id not in 
  (select ar.id
from appointment_requests ar
left join user_discounts ud on ud.id=ar.user_discount_id and ud.user_id=ar.user_id
left join discounts d on d.id=ud.discount_id
where ar.status  in ('completed') and date(convert_tz(session_time,'UTC',case timezone when 'Pacific Time (US & Canada)' then 'America/Los_Angeles' else timezone end)) in ('2017-09-23', '2017-09-24','2017-09-25') and d.code='fall15'
  )


 
 group by user_id

) z
on z.user_id=b.user_id
order by rank