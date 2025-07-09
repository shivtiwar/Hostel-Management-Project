CREATE database hostel;
use hostel;
create table hostel_info (
hostel_code varchar (5) Not null primary key,
vacant_room int unsigned not null
);

create table leader_data(
id varchar (13) not null unique primary key,
wing_size int unsigned not null,
preference1 char(2) not null,
preference2 char(2) not null,
preference3 char(2) not null
);

create table student_data (
id1 varchar (13) Not null primary key,
id2 varchar (13),
FOREIGN KEY (id2) REFERENCES leader_data(id)
);

create table hostel_allotment (
id varchar (13) not null primary key,
hostel_alloted varchar (2),
room_number int unsigned 
);

-- This procedure returns the number of vacant room in a hostel when hostel code is given as parameter
delimiter &&
CREATE  PROCEDURE `check_vacant_room`(in hostel_sym varchar(5) , out room_count int)
begin
	select vacant_room into room_count from hostel_info
    where hostel_code = hostel_sym;
END &&

-- this procedure is used when there is no space available in the preferenced hostel. So, we choose that hostel which has maximum vacant room availabe and allot that hostel to that wing.
delimiter &&
create procedure random_hostel_allocation (in id3 varchar(13), in wing_size int)
begin
	select hostel_code, vacant_room into @hostel_sym, @vacant_room from hostel_info order by vacant_room DESC Limit 1;
    if @vacant_room >= wing_size then 
		update hostel_info 
		set vacant_room = vacant_room - wing_size
		where hostel_code = @hostel_sym;
	else
		select 'Allocation not possible' as '';
    end if;
end &&

-- By executing this procedure complete hostel allotment can be performed. As a user you just have to call this procedure and we are done.
DELIMITER &&  
CREATE PROCEDURE hostel_allotment ()  
BEGIN  
    DECLARE n INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;   
    call final_table();
    SELECT COUNT(*) FROM all_data INTO n;
	SET i=0;
    WHILE i<n DO 
		Select id, exact_wing_size, preference1, preference2, preference3
        into @id, @exact_wing_size, @preference1, @preference2, @preference3
        from all_data
        LIMIT i,1;
        call check_vacant_room(@preference1, @room1);
        call check_vacant_room(@preference2, @room2);
        call check_vacant_room(@preference3, @room3);
        if @room1 >= @exact_wing_size then
			call hostel_room_allocation(@id, @preference1);
		elseif @room2 >= @exact_wing_size then 
			call hostel_room_allocation(@id, @preference2);
		elseif @room3 >= @exact_wing_size then 
			call hostel_room_allocation(@id, @preference3);
		else
			call random_hostel_allocation(@id, @exact_wing_size);
        end if;
		SET i = i + 1;
	END WHILE;
END &&  
DELIMITER ; 

-- This procedure allot the room in the hostel which are given as preference by the leader 
delimiter &&
create procedure hostel_room_allocation (in id3 varchar(13), in hostel_sym varchar(5))
begin
	select vacant_room into @room from hostel_info where hostel_code = hostel_sym;
	insert into hostel_allotment values
    (id3, hostel_sym, 500-@room);
    update hostel_info 
    set vacant_room = vacant_room -(select exact_wing_size from all_data where id=id3)
    where hostel_code = hostel_sym;
end &&

-- This procedure will help the leader to add their wing members inside student_data table.
delimiter &&
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_student`(IN wing_member_id VARCHAR(13), IN leader_id varchar(13))
BEGIN  
    Start transaction;
    insert into student_data values (wing_member_id, leader_id);
    update leader_data set wing_size = wing_size-1 where id = leader_id;
    select wing_size into @wing from leader_data where id = leader_id;
    if @wing >0 then
    commit;
    else 
    rollback;
    end if;
END &&

delimiter &&
CREATE DEFINER=`root`@`localhost` PROCEDURE `final_table`()
begin
	create table dst_tbl
	select id2 as id, count(*) as exact_wing_size
	from student_data
	group by id
	order by exact_wing_size DESC;

	update dst_tbl set exact_wing_size = exact_wing_size + 1;
 
	create table all_data select * from dst_tbl natural join leader_data order by exact_wing_size DESC;
    drop table dst_tbl;
end&&

-- drop table dst_tbl;
-- drop table all_data;
-- drop table hostel_allotment;
-- drop table hostel_info;
-- drop table leader_data;
-- drop table student_data;

-- drop procedure check_vacant_room;
-- drop procedure final_table;
-- drop procedure hostel_allotment;
-- drop procedure hostel_room_allocation;
-- drop procedure insert_student;
-- drop procedure random_hostel_allocation;




 


