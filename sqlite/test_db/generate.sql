create table if not exists person(
	pers_id integer primary key autoincrement,
	name text not null,
	surname text not null,
	birthday text not null
);

insert into person(name, surname, birthday)
with
names(name) as (
	values ('John'), ('Amanda'), ('Mark'), ('Lara'), ('Peter'),
	       ('Mary'), ('Stan'), ('Marta'), ('Linda'), ('David')
),
surnames(surname) as (
	values ('Brown'), ('Williams'), ('Manson'), ('Smith'), ('Johnson'),
			 ('Anderson'), ('Cox'), ('Clark'), ('Adams'), ('Cage')
),
ordinary as (
	select name, surname, random() r
	from names
	cross join surnames
	where substr(name, -1) in ('a', 'd') or surname <> 'Cox'
	  and substr(name, -1) in ('y', 'd', 'k') or surname in ('Clark', 'Manson')
),
bounds as (
	select strftime('%s', '1970-01-01') start,
			 strftime('%s', '2000-12-31') "end"
),
dates(id, birth) as (
	select 1, date(start + abs(random()) % (end - start), 'unixepoch')
	from bounds
	union all
	select id + 1, date(start + abs(random()) % (end - start), 'unixepoch')
	from dates, bounds where id < 50
)
select name, surname, birth
from ordinary, dates
order by row_number() over(partition by surname order by r), r
limit 100;

pragma synchronous = off;

create table if not exists tokens(
	id integer primary key autoincrement,
	created_at text not null,
	token text not null,
	is_active integer default 0 not null
);

insert into tokens(created_at, token, is_active)
with recursive seq(id) as (
	select 1
	union all
	select id + 1 from seq where id < 15000000
)
select datetime('2026-01-01', (abs(random()) % (150 * 86400)) || ' seconds'),
		 lower(hex(randomblob(8))), random() < .5
from seq;
