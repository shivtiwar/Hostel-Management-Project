select * from all_data;
select * from hostel_allotment;
select * from hostel_info;
select * from leader_data;
select * from student_data;

insert into leader_data values
('2019B4A70642P',2,'kr','bg','rm'),
('2019B5A70860P',4,'gn','kr','bd'), 
('2019B4A70718P', 5, 'vk','cv','sr'), 
('2019B4A80548P',3,'kr','rm','bg');

call insert_student('2019B3A70925P','2019B4A70642P');
call insert_student('2019B4A80725P','2019B4A70642P');

call insert_student('2018A2PS1032P','2019B4A80548P');
call insert_student('2020A7PS0003P','2019B4A80548P');
call insert_student('2020A7PS1676P','2019B4A80548P');

call insert_student('2018A8PS0413P','2019B5A70860P');
call insert_student('2019A3PS0187P','2019B5A70860P');
call insert_student('2019B3A70537P','2019B5A70860P');
call insert_student('2020A7PS1212P','2019B5A70860P');

call insert_student('2021A30908P','2019B4A70718P');
call insert_student('2021A40874P','2019B4A70718P');
call insert_student('2021A70742P','2019B4A70718P');
call insert_student('2021A11234P','2019B4A70718P');
call insert_student('2021A80569P','2019B4A70718P');

select * from student_data;

call hostel_allotment(); 






-- delete from leader_data;
-- delete from student_data;
-- delete from all_data;
-- delete from hostel_allotment;
