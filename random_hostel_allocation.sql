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