# Update order_id in machines after deleting customers
DROP TRIGGER IF EXISTS `multicloud`.`customer_AFTER_UPDATE`;
DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `multicloud`.`customer_AFTER_UPDATE` AFTER UPDATE ON `customer` FOR EACH ROW
BEGIN
update order_
set order_end_date = curdate()
where customer_id = new.customer_id;

SET SQL_SAFE_UPDATES = 0;

update order_,machine
set machine.order_id = null
where machine.order_id = order_.order_id and 
customer_id = new.customer_id;

 SET SQL_SAFE_UPDATES = 1;

END$$
DELIMITER ;