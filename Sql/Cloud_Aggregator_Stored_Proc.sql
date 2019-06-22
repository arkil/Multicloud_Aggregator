delimiter $$
create definer=`root`@`localhost` procedure `sp_create_ca`(
in ca_email_id varchar(200),
in ca_name varchar(200),
in ca_password varchar(200),
in ca_bank_account_number bigint
)
begin

	insert into ca ( ca_email_id, ca_name, ca_password, ca_bank_account_number) values (ca_email_id, ca_name, ca_password, ca_bank_account_number);

end$$
delimiter ;