delimiter $$
create definer=`root`@`localhost` procedure `sp_create_csp`(
in c_email_id varchar(200),
in c_name varchar(200),
in c_password varchar(200),
in c_bank_account_number bigint,
in c_ca_id int
)
begin
	declare exit handler for sqlexception
    begin
		select 'Error occured';
        rollback;
        resignal;
	end;
	start transaction;
	if ( select exists (select 1 from csp where csp_email_id = c_email_id) ) then

		select 'CSP exists !!';

	else

		insert into csp ( csp_email_id, csp_name, csp_password, csp_join_date, csp_bank_account_number) values (c_email_id, c_name, c_password, CURDATE(), c_bank_account_number);
		insert into csp_contracts (ca_id, csp_id) values (c_ca_id, (select csp_id from csp where csp_email_id=c_email_id));

end if;
end$$
delimiter ;