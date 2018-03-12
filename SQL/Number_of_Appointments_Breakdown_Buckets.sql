select 
case when (a.times>=5 and a.times <11) then '5-11'
when (a.times >=12 and a.times <23) then '12-23'
when (a.times >= 24 and a.times <49) then '24-49'
when (a.times >=50) then '>=50' else '<5'
end as Number_of_appointments,
count(*)
 
from
(select user_id, count(*) as times
from appointment_requests ar
where ar.status='completed' and ar.session_time>now()-interval 12 month and ar.session_time<now() 
group by user_id) as a

group by Number_of_appointments
order by field(Number_of_appointments, '<5','5-11','12-23','24-49','>=50')