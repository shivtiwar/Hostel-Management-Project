select * from student_data;
use hostel;
select * from leader_data;

create table dst_tbl
select id2 as id, count(*) as exact_wing_size
from student_data
group by id
order by exact_wing_size DESC;

select * from dst_tbl;
update dst_tbl set exact_wing_size = exact_wing_size + 1;
 
create table all_data select * from dst_tbl natural join leader_data;
select * from all_data;

select * from hostel_info;

