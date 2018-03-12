select sum(deep) as deep, sum(swedish) as swedish, sum(sports) as sports ,sum(prenatal) as prenatal,sum(party) as party 

from 
(select ar.session_time,
 
 case when (session_type_single='deep' or session_type_double_1='deep' or session_type_double_2='deep') then 1 else 0 end as deep,
 case when (session_type_single='swedish' or session_type_double_1='swedish' or session_type_double_2='swedish') then 1 else 0 end as swedish,
 case when (session_type_single='sports' or session_type_double_1='sports' or session_type_double_2='sports') then 1 else 0 end as sports,
 case when (session_type_single='prenatal' or session_type_double_1='prenatal' or session_type_double_2='prenatal') then 1 else 0 end as prenatal,
 case when (session_type_single='party' or session_type_double_1='party' or session_type_double_2='party') then 1 else 0 end as party
 
 from appointment_requests ar
 
 left join 
 (select c.id, c.name
  from cities c) as n
 on n.id=ar.city_id
 
 where n.name='Los Angeles' and ar.session_time>= last_day(now()) + interval 1 day - interval 6 month and ar.status='completed') as a