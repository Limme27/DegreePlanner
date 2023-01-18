
--drop view q2_helper;
create or replace view q2_helper
as
select p.code, a.name, r.type as r_type, min_req, max_req, a.type as s_type, a.definition as stream
from Programs p
    join program_rules pr on p.id = pr.program
    join Rules r on pr.rule = r.id
    join Academic_object_groups a on r.ao_group = a.id
;
-- drop view q2_helper_stream;
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
