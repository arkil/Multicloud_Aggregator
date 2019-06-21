drop database if exists multicloud;
create database multicloud;

use multicloud;

create table csp
(
  csp_id int not null auto_increment,
  csp_email_id varchar(255)  not null,
  csp_name varchar(255) not null,
  csp_password varchar(255) not null,
  csp_join_date date not null,
  csp_bank_account_number bigint not null,
  primary key (csp_id)
);

create table order_
(
  order_id int not null auto_increment,
  order_date date not null,
  number_of_machines int not null,
  # instance_type varchar(255) not null,
  ca_id int not null,
  customer_id int not null,
  cpu_cores int,
  ram int,
  disk_size varchar(20) not null,
  order_end_date date,
  order_amount int not null,
  order_cost int not null,
  primary key (order_id)
);

create table ca
(
  ca_id int not null auto_increment,
  ca_email_id varchar(255) not null,
  ca_name char(255) not null,
  ca_bank_account_number bigint not null,
  ca_password varchar(255) not null,
  primary key(ca_id)
);


create table customer
(
  customer_id int not null auto_increment,
  customer_email_id varchar(255) not null,
  customer_name char(255) not null,
  customer_password varchar(255) not null,
  customer_join_date date not null,
  customer_bank_account bigint(16) not null,
  customer_offer_id int,
  customer_isDelete boolean default false,
  primary key(customer_id)
);


create table bill
(
  bill_id int not null auto_increment,
  bill_amount int(12) not null,
  csp_id int,
  ca_id int not null,
  customer_id int,
  month int not null,
  year int not null,
  is_paid bool default False,
  primary key(bill_id)
);

create table offer
(
  offer_id int not null auto_increment,
  offer_name varchar(255) not null,
  discount int not null,
  ca_id int not null,
  valid_till date,
  is_used bool default False,
  primary key(offer_id)
);



create table machine
(
  mac_id int not null auto_increment,
  csp_id int not null,
  # gpu varchar(20) not null,
  disk_size varchar(20) not null,
  ram int(4) not null,
  cpu_cores int(4) not null,
  # os char(20) not null,
  ip_address varchar(16) not null,
  price int not null,
  order_id int,
  primary key(mac_id, csp_id)
);


create table receives
(
  csp_id int not null,
  order_id int not null,
  quantity int not null,
  csp_cost int not null,
  primary key (csp_id,order_id)
);

create table onboards
(
  ca_id int not null,
  customer_id int not null,
  primary key (ca_id, customer_id)
);


create table csp_contracts
(
  ca_id int not null,
  csp_id int not null,
  primary key(ca_id,csp_id)
);

create view order_customer as select order_id, order_date, number_of_machines, ca_id, customer_id, cpu_cores, ram, disk_size, order_end_date, order_amount from order_;

create view order_csp as select ord.order_id, ord.order_date, ord.number_of_machines, ord.ca_id, r.csp_id, ord.cpu_cores, ord.ram, ord.disk_size, ord.order_end_date, ord.order_cost
from order_ ord, receives r where ord.order_id=r.order_id;

create view machine_customer as select mac_id, disk_size, ram, cpu_cores, ip_address, order_id from machine;

create view customer_bill as select bill_id, customer_id, ca_id, month, year, bill_amount, is_paid from bill where csp_id is null;

create view ca_bill as select bill_id, ca_id, csp_id, month, year, bill_amount, is_paid from bill where customer_id is null;




alter table order_ add constraint fk_order_ca_id foreign key (ca_id) references ca(ca_id) ;
alter table order_ add constraint fk_order_customer_id foreign key (customer_id) references customer(customer_id);


alter table bill add constraint fk_bill_csp_id foreign key (csp_id) references csp(csp_id);
alter table bill add constraint fk_bill_ca_id foreign key (ca_id) references ca(ca_id);
alter table bill add constraint fk_bill_cust_id foreign key (customer_id ) references customer(customer_id);
alter table machine add constraint fk_machine_csp_id foreign key (csp_id) references csp(csp_id);
alter table machine add constraint fk_machine_order_id foreign key (order_id) references order_(order_id);
alter table receives add constraint fk_receives_csp_id foreign key (csp_id) references csp(csp_id);
alter table receives add constraint fk_receives_order_id foreign key (order_id) references order_(order_id);
alter table onboards add constraint fk_onboards_ca_id foreign key (ca_id) references ca(ca_id);
alter table onboards add constraint fk_onboards_customer_id foreign key (customer_id) references customer(customer_id);
alter table customer add constraint fk_customer_offer_id foreign key (customer_offer_id)  references offer(offer_id) on delete set null;
alter table offer add constraint fk_offer_ca_id foreign key (ca_id) references ca(ca_id);

-- alter table csp_contracts add constraint fk_csp_contracts_csp_id foreign key (csp_id) references csp(csp_id);
-- alter table csp_contracts add constraint fk_csp_contracts_ca_id foreign key (ca_id) references ca(ca_id);