delimiter &&
create procedure hostel_room_allocation (in id3 varchar(13), in hostel_sym varchar(5))
begin
	select vacant_room into @room from hostel_info where hostel_code = hostel_sym;
	insert into hostel_allotment values
    (id3, hostel_sym, 5-@room);
    update hostel_info 
    set vacant_room = vacant_room -(select exact_wing_size from all_data where id=id3)
    where hostel_code = hostel_sym;
end &&

-- delete from hostel_allotment where id = '2019B4A70718P';
-- delete from hostel_allotment where id ='2019B5A70860P';
-- call hostel_room_allocation('2019B4A70718P','vk');
-- select * from hostel_allotment;
-- call hostel_room_allocation('2019B5A70860P','vk');

