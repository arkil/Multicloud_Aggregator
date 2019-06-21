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



###### Ca
insert into ca values(12121,'abah@gmail.com','khas', 132121, 'pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e');
insert into ca values(232323,'sds@gmail.com','dsds', 12434121, 'pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e');
insert into ca values(4324323,'fdfds@gmail.com','hgh',5454545, 'pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e');
insert into ca values (123,'multicloud@gmail.com','multicloud',1361,'pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e');


###### Customer
insert into customer values (11224,'mitchstarc@gmail.com','mitch','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-09-09',3434,null, False);
insert into customer values (11225,'markwood@gmail.com','mark','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-09-19',3434,null, False);
insert into customer values (11226,'shane@gmail.com','Shane','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-09-29',3434,null, False);
insert into customer values (11227,'Brett@gmail.com','Brett','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-01-09',3434,null, False);
insert into customer values (11228,'Elon@gmail.com','Elon', 'pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-02-09',3434,null, False);
insert into customer values (11229,'John@gmail.com','John','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-03-09',3434,null, False);
insert into customer values (11220,'Wayne@gmail.com','Wayne','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-04-09',3434,null, False);
insert into customer values (11241,'Bruce@gmail.com','Bruce','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-09-05',3434,null, False);


###### CSP
insert into csp values (1234,'amazon@gmail.com','AWS','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-09-09',3434);
insert into csp values (1235,'google@gmail.com','Google','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-08-01',3435);
insert into csp values (1236,'microsoft@gmail.com','Azure','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-10-10',34346);
insert into csp values (12361,'VMwaret@gmail.com','vCloudAir','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-10-01',34347);
insert into csp values (12362,'Rackspace@gmail.com','RackConnect','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-11-10',34348);
insert into csp values (12363,'HPE@gmail.com','Right Mix','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-10-10',34349);
insert into csp values (12364,'EMC@gmail.com','VCE','pbkdf2:sha256:50000$PJ8gdds4$21c76a7ebbe9fd90740db011db11d1945c9806ff5b312a49ee362f9cc423416e','2000-12-10',343461);

##### Machines
#AWS Machines
insert into machine values(1334151,1234,'1TB',4,2,'123.65.254.22',20,null);
insert into machine values(1334152,1234,'1TB',4,2,'123.65.251.22',145,null);
insert into machine values(1334153,1234,'1TB',4,2,'123.65.254.32',100,null);
insert into machine values(1334154,1234,'1TB',4,8,'123.65.254.52',250,null);
insert into machine values(1334155,1234,'2TB',8,8,'123.65.251.12',450,null);
insert into machine values(1334156,1234,'2TB',8,4,'123.65.252.12',4500,null);
insert into machine values(1334157,1234,'2TB',8,4,'123.65.253.12',450000,null);

insert into machine values(1334158,1234,'4TB',4,8,'123.65.254.53',150,null);
insert into machine values(1334159,1234,'6TB',8,8,'123.65.251.12',420,null);
insert into machine values(1334160,1234,'8TB',8,4,'123.65.252.12',3500,null);
insert into machine values(1334161,1234,'2TB',8,4,'123.65.253.12',450000,null);

#Google
insert into machine values(1234151,1235,'1TB',4,4,'123.65.254.22',545,null);
insert into machine values(1134151,1235,'1TB',4,4,'123.65.254.32',145,null);
insert into machine values(13134151,1235,'2TB',4,4,'123.65.254.42',2345,null);
insert into machine values(134151,1235,'2TB',8,2,'123.65.254.52',450,null);
insert into machine values(1354151,1235,'2TB',8,2,'123.65.254.62',45000,null);

insert into machine values(131341551,1235,'2TB',4,4,'123.65.254.42',2345,null);
insert into machine values(13415154,1235,'6TB',8,2,'123.65.254.52',450,null);
insert into machine values(13541571,1235,'8TB',8,2,'123.65.254.62',45000,null);


#vCloud
insert into machine values(1114151,12361,'1TB',4,4,'121.65.254.12',100,null);
insert into machine values(1214151,12361,'1TB',8,2,'122.65.254.12',150,null);
insert into machine values(1314151,12361,'2TB',8,4,'124.65.254.12',250,null);

#Azure
insert into machine values(1334111,1236,'1TB',8,2,'123.65.254.11',145,null);
insert into machine values(1334121,1236,'1TB',8,4,'123.65.254.13',245,null);
insert into machine values(1334131,1236,'2TB',8,2,'123.65.254.12',415,null);
insert into machine values(1334141,1236,'2TB',4,2,'123.65.254.14',450,null);
insert into machine values(1334101,1236,'2TB',4,4,'123.65.254.15',4500,null);

#RackConnect
insert into machine values(1334111,12362,'1TB',8,4,'113.25.254.12',450,null);
insert into machine values(1334112,12362,'1TB',8,4,'113.26.254.12',100,null);
insert into machine values(1334113,12362,'2TB',4,4,'113.35.254.12',800,null);

#Right Mix
insert into machine values(1034151,12363,'1TB',4,4,'120.65.254.12',415,null);
insert into machine values(1934151,12363,'1TB',8,2,'129.65.254.12',425,null);
insert into machine values(1834151,12363,'2TB',4,4,'183.65.254.12',435,null);

#VCE
insert into machine values(1534151,12364,'1TB',8,2,'123.85.254.12',4500,null);
insert into machine values(1634151,12364,'2TB',4,4,'123.75.254.12',4590,null);
insert into machine values(1734151,12364,'2TB',8,4,'123.55.254.12',4580,null);



###### CSP_Contracts
insert into csp_contracts values (123,1234);
insert into csp_contracts values (123,1235);
insert into csp_contracts values (123,1236);
insert into csp_contracts values(12121,1234);
insert into csp_contracts values(12121,1235);
insert into csp_contracts values(12121,12361);
insert into csp_contracts values(12121,12364);

insert into csp_contracts values(232323,1234);
insert into csp_contracts values(232323,1235);
insert into csp_contracts values(232323,1236);
insert into csp_contracts values(232323,12364);

insert into csp_contracts values(4324323,1234);
insert into csp_contracts values(4324323,1235);
insert into csp_contracts values(4324323,1236);
insert into csp_contracts values(4324323,12361);
insert into csp_contracts values(4324323,12362);
insert into csp_contracts values(123,12363);
insert into csp_contracts values(4324323,12364);




###### Onboards
insert into onboards values (12121,11224);
insert into onboards values (12121,11225);
insert into onboards values (12121,11220);
insert into onboards values (12121,11241);

insert into onboards values (232323,11224);
insert into onboards values (232323,11225);
insert into onboards values (232323,11226);
insert into onboards values (232323,11227);
insert into onboards values (232323,11228);
insert into onboards values (232323,11229);
insert into onboards values (232323,11220);
insert into onboards values (232323,11241);

insert into onboards values (4324323,11224);
insert into onboards values (4324323,11225);
insert into onboards values (4324323,11226);
insert into onboards values (4324323,11227);
insert into onboards values (4324323,11228);
insert into onboards values (4324323,11229);
insert into onboards values (4324323,11220);
insert into onboards values (4324323,11241);




##### Offer
insert into offer values (4321,'Big Bang Offer',9,12121, null, False);
insert into offer values (4322,'Bumpper Offer',11,232323, null, False);
insert into offer values (4323,'Super Deal Offer',5,232323, null, False);
insert into offer values (4324,'Platinum Offer',20,4324323, null, False);
insert into offer values (4325,'Gold Bang Offer',15,4324323, null, False);
insert into offer values (4326,'Welcome Offer',10,123, null, False);

##### Bill
insert into bill values (0001,5000,1234,123,11224,'01','2000', False);
insert into bill values (0002,1000,12361,123,11227,'01','2000', False);
insert into bill values (0003,2000,12364,123,11220,'01','2000', False);


insert into bill values (1004,3000,1235,232323,11225,'02','2000', False);
insert into bill values (1005,53000,12362,232323,11228,'03','2000', False);
insert into bill values (1006,51000,1236,232323,11241,'01','2000', False);

insert into bill values (2004,4000,1236,4324323,11226,'07','2000', False);
insert into bill values (2005,43000,12364,4324323,11229,'08','2000', False);
insert into bill values (2006,41000,1235,4324323,11241,'09','2000', False);




##### Order
insert into order_ values(0010,'2000-02-01',5,12121,11224,16,16,"1TB",'2000-10-10', 40, 30);
insert into order_ values(0011,'2000-03-01',10,4324323,11227,16,16,"1TB",'2000-10-10', 50, 40);
insert into order_ values(0012,'2000-04-01',4,232323,11226,16,16,"2TB",'2000-10-10', 40, 30);

insert into order_ values(1010,'2000-11-01',5,232323,11225,32,16,"2TB",'2001-10-10', 60, 30);
insert into order_ values(1011,'2000-12-01',5,12121,11228,4,16,"1TB",'2001-10-10', 70, 30);
insert into order_ values(1012,'2000-02-01',5,4324323,11229,8,16,"2TB",'2000-10-10', 50, 40);

insert into order_ values(2011,'2000-01-01',5,12121,11220,8,16,"2TB",'2000-10-10', 70, 60);
insert into order_ values(2012,'2000-11-01',15,4324323,11241,8,16,"1TB",'2001-10-10', 70, 30);
insert into order_ values(2013,'2000-01-01',5,4324323,11229,8,16,"2TB",null, 25, 20);


##### Receives
insert into receives values(1234,0010,5,30);
insert into receives values(12361,0011,10,40);
insert into receives values(1236,0012,4,50);
insert into receives values(1235,1010,5,40);
insert into receives values(12362,1011,5,40);
insert into receives values(12364,1012,5,30);
insert into receives values(12364,2011,5,50);
insert into receives values(1235,2012,15,30);
insert into receives values(12364,2013,5,50);

insert into bill values (2004,4000,1236,4324323,11226,'07','2000', False);
insert into bill values (2005,43000,12364,4324323,11229,'08','2000', False);
insert into bill values (2006,41000,1235,4324323,11241,'09','2000', False);



