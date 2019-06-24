use multicloud $$
create definer=`root`@`localhost` procedure `sp_update_customer_admin`(
    in sp_id int,
    in sp_email_id varchar(255) ,
    in sp_name varchar(255) ,
    in sp_bank_account_number bigint,
 	in sp_offer_id int )
begin
    if (select exists (select 1 from customer where customer_id = sp_id)) then
        update customer set customer_name = sp_name, customer_email_id = sp_email_id, customer_bank_account = sp_bank_account_number, customer_offer_id=sp_offer_id where customer_id = sp_id;
	else
        select 'Not enough resources available!!';
    end if;
end$$ delimiter ;