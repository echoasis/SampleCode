select b.therapist_id, ifnull(b.complete,0) as number_complete, ifnull(c.checkin_out,0) as Check_in_and_check_out, ifnull(d.miss_checkin,0) as missing_check_in,ifnull(e.miss_checkout,0) as missing_check_out,ifnull(f.miss_both,0) as missing_both

from (select therapist_id,
      count(*) as complete

from appointments a
      where a.status='complete' or a.status='reviewed'
      group by a.therapist_id) as b

left join (select therapist_id, count(*) as checkin_out
      from appointments a
      where (a.status='complete' or a.status='reviewed') and (a.checked_in_at IS NOT NULL and a.checked_out_at IS NOT NULL)
      group by a.therapist_id) as c
on c.therapist_id=b.therapist_id

left join (select therapist_id, count(*) as miss_checkin
      from appointments a
      where (a.status='complete' or a.status='reviewed') and (a.checked_in_at IS NULL and a.checked_out_at IS NOT NULL)
           group by a.therapist_id) as d
on d.therapist_id=b.therapist_id

left join (select therapist_id, count(*) as miss_checkout
      from appointments a
      where (a.status='complete' or a.status='reviewed') and (a.checked_in_at IS NOT NULL and a.checked_out_at IS NULL)
           group by a.therapist_id) as e
on e.therapist_id=b.therapist_id

left join (select therapist_id, count(*) as miss_both
      from appointments a
      where (a.status='complete' or a.status='reviewed') and (a.checked_in_at IS NULL and a.checked_out_at IS NULL)
           group by a.therapist_id) as f
on f.therapist_id=b.therapist_id

where b.therapist_id IS NOT NULL