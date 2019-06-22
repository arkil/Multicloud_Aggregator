delimiter $$
create definer=`root`@`localhost` procedure `sp_create_customer`(
in sp_email_id varchar(255),
in sp_name varchar(255),
in sp_password varchar(255),
in sp_bank_account_number bigint,
in sp_ca_id int
)
begin

	declare temp_custId int default 0;
	declare exit handler for sqlexception
    begin
		select 'Error occured';
        rollback;
        resignal;
	end;
	start transaction;
		if ( select exists (select 1 from customer where customer_email_id = sp_email_id) ) then

			select 'Customer exists !!';

		else

			insert into customer (customer_email_id, customer_name, customer_password, customer_join_date, customer_bank_account, customer_offer_id) values (sp_email_id, sp_name, sp_password, CURDATE(), sp_bank_account_number, null);
			insert into onboards (ca_id, customer_id) values (sp_ca_id, (select customer_id from customer where customer_email_id=sp_email_id));

end if;
end$$
delimiter ;