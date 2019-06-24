delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_generate_bill_csp`(
in sp_day int,
in sp_month int,
in sp_year int,
in sp_csp_id int,
in sp_ca_id int
)
begin

declare order_month int;
declare order_start_day int;
declare order_end_day int;
declare order_cost int;
declare total_monthly_bill int;
declare finished int default 0;
declare ca_order_cursor cursor for select month(o.order_date) as order_month, day(o.order_date) as order_start_day, day(o.order_end_date) as order_end_day, r.csp_cost as order_cost
from order_ as o join receives as r on o.order_id = r.order_id and r.csp_id = sp_csp_id and o.ca_id = sp_ca_id and ( (o.order_end_date is null) or (month(o.order_end_date) = sp_month and year(o.order_end_date) = sp_year));
declare continue handler for not found set finished = 1;

declare exit handler for sqlexception
    begin
		select 'Error occured';
        rollback;
        resignal;
	end;
set total_monthly_bill = 0;

start transaction;

open ca_order_cursor;

get_ca_order: LOOP
 FETCH ca_order_cursor INTO order_month, order_start_day, order_end_day, order_cost;
 IF finished = 1 THEN
  LEAVE get_ca_order;
 END IF;
 -- compute cost
 IF order_month < sp_month THEN
  IF order_end_day is null THEN
   set total_monthly_bill = total_monthly_bill + (30 * order_cost);
  ELSE
   set total_monthly_bill = total_monthly_bill + (order_end_day * order_cost);
  END IF;
 ELSEIF order_month = sp_month THEN
  IF order_end_day is null THEN
   set total_monthly_bill = total_monthly_bill + ( (30 - order_start_day + 1) * order_cost);
  ELSE
   set total_monthly_bill = total_monthly_bill + ( (order_end_day - order_start_day + 1) * order_cost);
  End IF;
 END IF;
END LOOP get_ca_order;

close ca_order_cursor;

insert into bill (bill_amount, csp_id, ca_id, customer_id, month, year, is_paid) values (total_monthly_bill, sp_csp_id, sp_ca_id, null, sp_month, sp_year, False);

select concat("New bill with cost: ", total_monthly_bill," generated for ca: ", sp_ca_id, " by csp: ", sp_csp_id, " for month: ", sp_month, " year: ", sp_year);

commit;

end$$
delimiter ;