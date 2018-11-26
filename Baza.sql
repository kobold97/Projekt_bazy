create table company (
    company_name varchar2(100) not null,
    company_delivery_name varchar2(100) default '',
    company_main_headquaters number not null
);

create table region (
    region_id number not null,
    region_name varchar2(100) not null,
    constraint region_primary_key primary key (region_id)
);

create table country (
    country_id number not null,
    country_name varchar2(100),
    region_id number not null,
    constraint country_primary_key primary key (country_id),
    constraint country_foreign_key foreign key (region_id) references region(region_id)
);

create table city (
    city_id number not null,
    city_name varchar2(100) not null,
    country_id number not null,
    constraint city_primary_key primary key (city_id),
    constraint city_foreign_key foreign key (country_id) references country(country_id)
);

create table location (
    location_id number not null,
    street_name varchar2(100) not null,
    postal_code varchar2(20) not null,
    location_type char default null,
    city_id number not null,
    constraint location_primary_key primary key (location_id),
    constraint location_foreign_key_city foreign key (city_id) references city(city_id),
);

create table chain (
    chain_id number not null,
    chain_name varchar2(100),
    region_id number not null,
    constraint chain_primary_key primary key  (chain_id),
    constraint chain_foreign_key foreign key (region_id) references region(region_id)
);

create table warehouse (
    warehouse_id number not null,
    warehouse_name varchar2(100),
    location_id number not null,
    constraint warehouse_primary_key primary key (warehouse_id),
    constraint warehouse_foreign_key_location foreign key (location_id) references location(location_id)
);

create table store (
    store_id number not null,
    store_name varchar2(100),
    location_id number not null,
    warehouse_id number not null,
    constraint store_primary_key primary key(store_id),
    constraint store_foreign_key_location foreign key (location_id) references location(location_id),
    constraint store_foreign_key_warehouse foreign key (warehouse_id) references warehouse(warehouse_id)
);

create table department (
    department_id number not null,
    department_name varchar2(100),
    location_id number not null,
    store_id number not null,
    constraint department_primary_key primary key (department_id),
    constraint department_foreign_key_store foreign key (store_id) references store(store_id),
    constraint department_foreign_key_loc foreign key (location_id) references location(location_id)
);

create table supplier (
    supplier_id number not null,
    supplier_name varchar2(100),
    constraint supplier_primary_key primary key (supplier_id)
);

create table item (
    item_id number not null,
    item_name varchar2(100) not null,
    item_size char not null,
    supplier_id number not null,
    constraint item_primary_key primary key (item_id),
    constraint item_foreign_key foreign key (supplier_id) references supplier(supplier_id)
);

create table stock (
    stock_id number not null,
    quantity number not null,
    item_id number not null,
    warehouse_id number not null,
    constraint stock_primary_key primary key (stock_id),
    constraint stock_foreign_key_warehouse foreign key (warehouse_id) references warehouse(warehouse_id),
    constraint stock_foreign_key_item foreign key (item_id) references item(item_id)
);

alter table location 
    add constraint location_check check (location_type in ('W', 'S', 'D'));

create table log (
    table_name varchar2(100),
    log_message varchar2(100)
);

create sequence company_seq
    increment by 1;
    
create sequence region_seq
    increment by 1;
    
create sequence country_seq
    increment by 1;

create sequence city_seq
    increment by 1;

create sequence location_seq
    increment by 1;

create sequence warehouse_seq
    increment by 1;

create sequence store_seq
    increment by 1;

create sequence department_seq
    increment by 1;

create sequence item_seq
    increment by 1;

create sequence supplier_seq
    increment by 1;
    
create sequence stock_seq
    increment by 1;

create sequence chain_seq
    increment by 1;
    
/
create or replace procedure reset_base_seq(sequence_name varchar) as
    temp number;
begin
    execute immediate 'select ' || sequence_name || '.nextval from dual' into temp;
    execute immediate 'alter sequence ' || sequence_name || ' increment by -' || temp || ' minvalue 0';
    execute immediate 'select ' || sequence_name || '.nextval from dual' into temp;
    execute immediate 'alter sequence ' || sequence_name || ' increment by 1';
end;
/

/
create or replace trigger warehouse_logging 
    after 
        update or
        insert or 
        delete on warehouse
        for each row
declare
    log_message varchar2(100);
    pragma autonomous_transaction;
begin
    if inserting
        then
            log_message := 'inserted new warehouse ' || :new.warehouse_name || ' into warehouse table';        
            insert into log values ('warehouse', log_message);
    end if;
    commit;
end;
/

insert into region values (region_seq.nextval, 'Europe');
insert into country values (country_seq.nextval, 'Poland', 1);
insert into city values (city_seq.nextval, 'Warsaw', 1);
insert into location values (location_seq.nextval, 'Ogrodowa 12', '23-234', 'W', 1);
insert into warehouse values (warehouse_seq.nextval, 'TK MAX', 1);

select * from log;