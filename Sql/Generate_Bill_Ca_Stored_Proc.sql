delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_generate_bill_ca`(
in sp_day int,
in sp_month int,
in sp_year int,
in sp_ca_id int,
in sp_customer_id int
)
begin

declare order_month int;
declare order_start_day int;
declare order_end_day int;
declare order_amount int;
declare total_monthly_bill int;
declare id int;
declare discount int;
declare offer_discount int default 0;
declare offer_id int default null;
declare finished int default 0;
declare customer_order_cursor cursor for select month(o.order_date) as order_month, day(o.order_date) as order_start_day, day(o.order_end_date) as order_end_day, o.order_amount as order_amount
from order_ as o join customer as c on o.customer_id = c.customer_id and o.customer_id = sp_customer_id and o.ca_id = sp_ca_id and (o.order_end_date is null or (month(o.order_end_date) = sp_month and year(o.order_end_date) = sp_year));
declare customer_offer_cursor cursor for select o.offer_id, o.discount
from offer as o join customer as c on o.offer_id = c.customer_offer_id and o.ca_id = sp_ca_id and o.is_used is False and (sp_month < month(o.valid_till) or (month(o.valid_till) = sp_month and 30 <= day(o.valid_till))) and year(o.valid_till) <= sp_year;
declare continue handler for not found set finished = 1;

declare exit handler for sqlexception
    begin
		select 'Error occured';
        rollback;
        resignal;
	end;

start transaction;
set total_monthly_bill = 0;

open customer_order_cursor;

get_customer_order: LOOP
 FETCH customer_order_cursor INTO order_month, order_start_day, order_end_day, order_amount;
 IF finished = 1 THEN
  LEAVE get_customer_order;
 END IF;
 -- compute cost
 IF order_month < sp_month THEN
  IF order_end_day is null THEN
   set total_monthly_bill = total_monthly_bill + (30 * order_amount);
  ELSE
   set total_monthly_bill = total_monthly_bill + (order_end_day * order_amount);
  END IF;
 ELSEIF order_month = sp_month THEN
  IF order_end_day is null THEN
   set total_monthly_bill = total_monthly_bill + ( (30 - order_start_day + 1) * order_amount);
  ELSE
   set total_monthly_bill = total_monthly_bill + ( (order_end_day - order_start_day + 1) * order_amount);
  End IF;
 END IF;
END LOOP get_customer_order;

close customer_order_cursor;

open customer_offer_cursor;

get_customer_offer: LOOP
 FETCH customer_offer_cursor INTO id, discount;
 IF finished = 1 THEN
  LEAVE get_customer_offer;
 END IF;
 -- find max offer
 IF offer_discount < discount THEN
  set offer_discount = discount;
  set offer_id = id;
 END IF;
END LOOP get_customer_offer;

close customer_offer_cursor;

IF (offer_id is not null) and (offer_discount != 0) THEN
 set total_monthly_bill = convert(total_monthly_bill * ((100 - offer_discount)/100),unsigned int);
 update offer as o set o.is_used = True where o.offer_id = offer_id and o.discount = offer_discount;
END IF;

insert into bill (bill_amount, csp_id, ca_id, customer_id, month, year, is_paid, offer_id) values (total_monthly_bill, null, sp_ca_id, sp_customer_id, sp_month, sp_year, False, offer_id);

select concat("New bill with cost: ", total_monthly_bill, " with discount: ", offer_discount," generated for customer: ", sp_customer_id, " by ca: ", sp_ca_id, " for month: ", sp_month, " year: ", sp_year);
commit;

end$$
delimiter ;