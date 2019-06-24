delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_update_ca`(
    in sp_id int,
    in sp_email_id varchar(255) ,
    in sp_name varchar(255) ,
    in sp_password varchar(255),
    in sp_bank_account_number bigint
)
begin
    if (select exists (select 1 from ca where ca_id = sp_id)) then
		update ca set ca_name = sp_name, ca_email_id = sp_email_id, ca_password = sp_password, ca_bank_account_number = sp_bank_account_number where ca_id=sp_id;
    else
        select 'Not enough resources available!!';
    end if;
end$$
delimiter ;