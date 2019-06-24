delimiter $$
use multicloud $$
create definer=`root`@`localhost` procedure `sp_update_csp`(
    in sp_id int,
    in sp_email_id varchar(255) ,
    in sp_name varchar(255) ,
    in sp_password varchar(255),
    in sp_bank_account_number bigint
)
begin
    if (select exists (select 1 from csp where csp_id = sp_id)) then
        update csp set csp_name = sp_name, csp_email_id = sp_email_id, csp_password = sp_password, csp_bank_account_number = sp_bank_account_number where csp_id = sp_id;
    else
        select 'Not enough resources available!!';
    end if;
end$$ delimiter ;