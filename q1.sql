
drop view q1_helper;
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

-- select code, term, name::text, mark, grade::CHAR(2), uoc from q1_helpe where student = _zid order by term, code
