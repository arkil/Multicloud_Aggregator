delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_end_order`(
    in sp_order_id int,
    in sp_order_id_2 int)
begin
    if (select exists (select 1 from order_ where order_id = sp_order_id)) then
        update order_ set order_end_date = curdate() where order_id = sp_order_id;
        update machine set order_id=null where order_id = sp_order_id;
	else
        select 'Not enough resources available!!';
    end if;
end$$ delimiter ;