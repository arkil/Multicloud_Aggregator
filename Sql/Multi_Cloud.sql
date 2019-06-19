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
