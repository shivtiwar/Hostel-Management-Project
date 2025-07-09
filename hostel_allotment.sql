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