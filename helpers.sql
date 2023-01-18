-- Q1
create or replace view q1_helper
as
select ce.student, s.code, t.id, t.code as Term, s.name, ce.mark, ce.grade, s.uoc
from Course_enrolments ce 
    join Courses c on ce.course = c.id
    join Terms t on c.term = t.id
    join Subjects s on c.subject = s.id
;

create or replace function
	q1(_zid integer) returns setof TranscriptRecord
as $$
declare
    b TranscriptRecord;
begin
    for b in  
        select code, term, name, mark, grade, uoc from q1_helper 
        where student = _zid
        order by id, code
    loop
        return next b;
    end loop;
end;
$$
language plpgsql;

-- Q2
create or replace view q2_helper
as
select p.code, a.name, r.type as r_type, min_req, max_req, a.type as s_type, a.definition as stream
from Programs p
    join program_rules pr on p.id = pr.program
    join Rules r on pr.rule = r.id
    join Academic_object_groups a on r.ao_group = a.id
;

create or replace view q2_helper_stream
as
select s.code, s.name, r.name as r_name, r.type as r_type, min_req as min, max_req as max, 
a.type as type, a.definition as stream
from Streams s
    join stream_rules sr on s.id = sr.stream
    join Rules r on sr.rule = r.id
    join Academic_object_groups a on r.ao_group = a.id
;

create or replace function
	q2_program(_code char(4)) returns setof q2_helper
as $$
    select * from q2_helper where code = _code
$$
language sql;

create or replace function
	q2_stream(_code char(6)) returns setof q2_helper_stream
as $$
    select * from q2_helper_stream where code = _code
$$
language sql;

create or replace function
	q2_stream_name(_code char(6)) returns LongName
as $$
    select name from Streams where code = _code
$$
language sql;

create or replace function
	q2_subject_name(_code char(8)) returns MediumName
as $$
    select name from Subjects where code = _code
$$
language sql;

-- Q3
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