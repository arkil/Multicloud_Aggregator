delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_update_customer`(
    in sp_id int,
    in sp_email_id varchar(255) ,
    in sp_name varchar(255) ,
    in sp_password varchar(255),
    in sp_bank_account_number bigint)
begin
    if (select exists (select 1 from customer where customer_id = sp_id)) then
        update customer set customer_name = sp_name, customer_email_id = sp_email_id, customer_password = sp_password, customer_bank_account = sp_bank_account_number where customer_id = sp_id;
	else
        select 'Not enough resources available!!';
    end if;
end$$ delimiter ;
