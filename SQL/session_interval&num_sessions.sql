set @c_user='',@rank=0;
 
select f1.user_id,timestampdiff(day,f1.session_time,f2.session_time) as interval_between_bookings,f1.rank 
 from
 (
 select user_id,rank,session_time
 from
 (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time
 from
 (select user_id,session_time
 
 
 from appointment_requests
 where status='completed'
 
 order by user_id,session_time)a)a
)f1
 
 join
  (
  select user_id,rank,session_time
  from
  (select user_id,if(@c_user=user_id,@rank:=@rank+1,@rank:=1) as rank, @c_user:=user_id,session_time
 from
 (select user_id,session_time
 
 
 from appointment_requests
 where status='completed'
 
 order by user_id,session_time)a)a
)f2 on f1.rank=f2.rank-1 and f1.user_id=f2.user_id