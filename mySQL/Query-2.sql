-- martian is the left table
-- base is the right table
select
	m.martain_id,
	b.base_id,
	b.base_name
from
	martian as m
inner join base as b
on
	m.base_id = b.base_id;
	
-- eveyting
select
	*
from
	martian
full join base
on
	martian.base_id = base.base_id;
	

-- left join: everyting from the martian table
select
	*
from
	martian
left join base 
on
	martian.base_id = base.base_id;
	


-- right join: everyting from the base table
select
	*
from
	martian
right join base 
on
	martian.base_id = base.base_id;