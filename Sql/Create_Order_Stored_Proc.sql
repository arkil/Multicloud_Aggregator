delimiter $$
create definer=`root`@`localhost` procedure `sp_create_order`(
in sp_email_id varchar(255),
in sp_ram int,
in sp_cpu int,
in sp_disk_size varchar(255),
in sp_no_of_machines int,
in sp_customer_id int,
in sp_ca_id int
)
begin

	declare temp_count int;
	declare temp_price int;
	declare temp_last_order_id int;

	declare exit handler for sqlexception
    begin
		select 'Error occured';
        rollback;
        resignal;
	end;
	start transaction;

		select count(s.mac_id), sum(s.price) into temp_count, temp_price  from (select m.* from csp_contracts c join machine m on c.csp_id=m.csp_id where c.ca_id=sp_ca_id and m.cpu_cores=sp_cpu and m.ram=sp_ram and m.disk_size=sp_disk_size and m.order_id is null order by m.price limit sp_no_of_machines) as s;

		if ( temp_count = sp_no_of_machines ) then

		insert into order_ (order_date, number_of_machines, ca_id, customer_id, cpu_cores, ram, disk_size, order_end_date, order_amount, order_cost) values (CURDATE(), sp_no_of_machines,sp_ca_id,sp_customer_id, sp_cpu, sp_ram, sp_disk_size, null, temp_price*1.2, temp_price);
		#select m.mac_id, m.csp_id, m.price from csp_contracts c join machine m on c.csp_id=m.csp_id where c.ca_id=sp_ca_id and m.cpu_cores=sp_cpu and m.ram=sp_ram and m.disk_size=sp_disk_size order by m.price limit 1;

		set temp_last_order_id = LAST_INSERT_ID();

        update  machine m1 join (select m.mac_id from csp_contracts c join machine m on c.csp_id=m.csp_id where c.ca_id=sp_ca_id and m.cpu_cores=sp_cpu and m.ram=sp_ram and m.disk_size=sp_disk_size and m.order_id is null order by m.price limit sp_no_of_machines) s
		on m1.mac_id=s.mac_id set m1.order_id=temp_last_order_id;

		insert into receives (csp_id, order_id, csp_cost, quantity) select m.csp_id, m.order_id, sum(m.price), count(m.mac_id) from machine m where m.order_id=temp_last_order_id group by m.csp_id;

		else
		select 'Not enough resources available!!';
		end if;

end$$
delimiter ;
