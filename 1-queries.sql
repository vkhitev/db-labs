BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE agent';
  EXECUTE IMMEDIATE 'DROP TABLE bill_supply';
  EXECUTE IMMEDIATE 'DROP TABLE bill_shipment';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
       RAISE;
    END IF;
END;

create table agent (
  id number not null,
  name varchar2(200) not null,
  address varchar2(200) not null,
  bank_details varchar2(200) not null,

  constraint agent_pk primary key (id)
);

alter table agent
  add rest_sugar number default 0;
  
alter table agent
  add rest_bagasse number default 0;

create table supply (
  id number not null,
  bill_date date not null,
  beet_supplied number not null,
  sugar_estimated number not null,
  bagasse_estimated number not null,

  constraint supply_pk primary key (id)
);

create table shipment (
  id number not null,
  bill_date date not null,
  sugar_shipped number not null,
  bagasse_shipped number not null,

  supply_id number not null,

  constraint shipment_pk primary key (id)
);

alter table supply
  add agent_id number not null;
  
alter table supply
  add constraint supply_fk1
  foreign key (agent_id)
  references agent (id);
  
alter table shipment
  add agent_id number not null;

alter table shipment
  add constraint shipment_fk2
  foreign key (agent_id)
  references agent (id);

alter table shipment
  add constraint shipment_fk1
  foreign key (supply_id)
  references supply (id);

--alter table shipment
--  add constraint supply_unique
--  unique (supply_id);



CREATE SEQUENCE agent_seq START WITH 1;
CREATE SEQUENCE supply_seq START WITH 1;
CREATE SEQUENCE shipment_seq START WITH 1;

CREATE OR REPLACE TRIGGER agent_bir 
  BEFORE INSERT ON agent 
  FOR EACH ROW
BEGIN
  SELECT agent_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
END;

CREATE OR REPLACE TRIGGER supply_bir 
  BEFORE INSERT ON agent 
  FOR EACH ROW
BEGIN
  SELECT supply_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
END;

CREATE OR REPLACE TRIGGER shipment_bir 
  BEFORE INSERT ON agent 
  FOR EACH ROW
BEGIN
  SELECT shipment_seq.NEXTVAL
    INTO   :new.id
    FROM   dual;
END;

insert all
  into agent (name, address, bank_details) values ('Адаменко Владислав', 'Украина, Донецкая область, Мариуполь, улица Гродненская, 49', '1198-6123-9744-4635')
  into agent (name, address, bank_details) values ('Бевз Дмитрий', 'Украина, Сумская область, Конотоп, улица Верболозная, 88', '4716-5882-4845-3884')
  into agent (name, address, bank_details) values ('Бондар Максим', 'Украина, Днепропетровская область, Павлоград, улица Лобачевского, 61', '7991-1489-3657-2473')
  into agent (name, address, bank_details) values ('Ботвинко Дарья', 'Украина, Херсонская область, Херсон, Днепровский переулок, 52', '4882-8678-1879-4727')
  into agent (name, address, bank_details) values ('Бузинный Александр', 'Украина, Черкасская область, Буки, улица Платона Майбороды, 88', '7955-6924-9684-3383')
  into agent (name, address, bank_details) values ('Волошин Денис', 'Украина, Киевская область, Бровары, Спортивная площадь, 58', '5875-8521-7369-8697')
  into agent (name, address, bank_details) values ('Дифучина Александра', 'Украина, Одесская область, Каменское, метро Дорогожичи, 15', '1676-8339-4551-3772')
  into agent (name, address, bank_details) values ('Жовтун Виктория', 'Украина, Кировоградская область, Ровеньки, Деснянская улица, 13', '4798-1917-8166-1935')
  into agent (name, address, bank_details) values ('Камышанов Владимир', 'Украина, Запорожская область, Энергодар, улица Коростенская, 51', '5884-4368-4149-5759')
  into agent (name, address, bank_details) values ('Косенко Владислав', 'Украина, Ровенская область, Антополь, бульвар Верховного Совета, 1', '6572-5452-1352-9769')
  into agent (name, address, bank_details) values ('Клименко Вадим', 'Украина, Полтавская область, Полтава, улица Радостная, 95', '8293-5532-6247-4172')
  into agent (name, address, bank_details) values ('Кучмий Антонина', 'Украина, Ивано-Франковская область, Бурштын, улица Дружбы, 20', '9166-9967-6739-3282')
  into agent (name, address, bank_details) values ('Лесниченко Роман', 'Украина, Донецкая область, Зугрес, Мичурина переулок, 31', '1678-6725-8946-7889')
  into agent (name, address, bank_details) values ('Любченко Глеб', 'Украина, Киевская область, Белая Церковь, Февральская улица, 5', '6735-3777-6972-8965')
  into agent (name, address, bank_details) values ('Михайленко Олег', 'Украина, Днепропетровская область, Кривой Рог, улица Маршала Малиновского, 100', '1748-6611-1184-2512')
  into agent (name, address, bank_details) values ('Обёртышев Анатолий', 'Украина, Запорожская область, Камыш-Заря, улица Андреевская, 97', '9786-1427-5996-7235')
  into agent (name, address, bank_details) values ('Романченко Богдан', 'Украина, Волынская область, Ковель, улица Смирнова, 24', '1488-1234-8841-4321')
  into agent (name, address, bank_details) values ('Романчук Иван', 'Украина, Львовская область, Львов, улица Филиппа Козицкого, 59', '7821-5397-5946-8167')
  into agent (name, address, bank_details) values ('Савченко Влад', 'Украина, Волынская область, Нововолынск, улица Яснополянская, 99', '6528-2791-4598-3353')
  into agent (name, address, bank_details) values ('Сердюк Евгений', 'Украина, Житомирская область, Бердичев, улица Старонаводницкая, 46', '7577-4997-2473-4142')
  into agent (name, address, bank_details) values ('Труба Александр', 'Украина, Львовская область, Дрогобыч, Лабораторный переулок, 59', '9215-4855-7931-8277')
  into agent (name, address, bank_details) values ('Хитёв Владислав', 'Украина, Хмельницкая область, Волочиск, улица Генерала Матыкина, 6', '3538-6495-5386-5549')
select 1 from dual;

insert all
  into supply (agent_id, bill_date, beet_supplied, sugar_estimated, bagasse_estimated) values (41, TO_DATE('2016/10/01', 'yyyy/mm/dd'), 1000, 140, 700)
  into supply (agent_id, bill_date, beet_supplied, sugar_estimated, bagasse_estimated) values (43, TO_DATE('2016/10/02', 'yyyy/mm/dd'), 1100, 155, 800)
  into supply (agent_id, bill_date, beet_supplied, sugar_estimated, bagasse_estimated) values (45, TO_DATE('2016/10/03', 'yyyy/mm/dd'), 1050, 160, 900)
  into supply (agent_id, bill_date, beet_supplied, sugar_estimated, bagasse_estimated) values (47, TO_DATE('2016/10/04', 'yyyy/mm/dd'), 1200, 170, 850)
  into supply (agent_id, bill_date, beet_supplied, sugar_estimated, bagasse_estimated) values (49, TO_DATE('2016/10/05', 'yyyy/mm/dd'), 1070, 165, 750)
select 1 from dual;

insert all
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (41, 6, TO_DATE('2016/10/10', 'yyyy/mm/dd'), 140, 600)
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (43, 7, TO_DATE('2016/10/14', 'yyyy/mm/dd'), 155, 700)
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (45, 8, TO_DATE('2016/10/15', 'yyyy/mm/dd'), 160, 800)
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (47, 9, TO_DATE('2016/10/17', 'yyyy/mm/dd'), 170, 750)
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (49, 10, TO_DATE('2016/10/20', 'yyyy/mm/dd'), 165, 650)
select 1 from dual;

insert all
  into shipment (agent_id, supply_id, bill_date, sugar_shipped, bagasse_shipped) values (49, 10, TO_DATE('2016/10/21', 'yyyy/mm/dd'), 0, 100)
select 1 from dual;

update agent
  set agent.rest_bagasse = 100
  where agent.id in (41, 43, 45, 47);
