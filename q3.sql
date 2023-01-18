--drop view q3_helper;
create or replace view q3_helper
as
select pe.student, t.id as t_id, 
    p.code as p_code, p.name as p_name, p.uoc,
    s.code as s_code, s.name as s_name
from program_enrolments pe
    join Programs p on pe.program = p.id
    join stream_enrolments se on pe.id = se.partof
    join streams s on se.stream = s.id
    join terms t on pe.term = t.id
;


create or replace function
	q3_most_recent_term(_id integer) returns q3_helper
as $$
    select * from q3_helper where student = _id
    order by t_id desc limit 1
$$
language sql;