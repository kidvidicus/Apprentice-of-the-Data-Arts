--materials type data insert - material_type, item_description, notes, material_name, url_link
```
insert into materials (
  material_type,
  item_description,
  notes,
  material_name,
  url_link
)
select distinct
  s.material_type,
  s.item_description,
  s.notes,
  s.material_name,
  s.url_link
from staging_materials s
where not exists (
  select 1
  from materials m
  where m.material_name = s.material_name
  and m.item_description = s.item_description);
```
--vendor Name data insert 
```  
insert into vendors (vendor_name)
select distinct trim(vendor)
from staging_materials
where vendor is not null
  and trim(vendor) <> '';
```
--class name data insert
```
insert into classes (class_name)
select distinct class_name
from staging_materials
where class_name is not null
  and trim(class_name) <> '';
```
  
--bridge table data load - material_vendor_items
```
insert into material_vendor_items (material_id, vendor_id, vendor_item_number)
select
  m.material_id,
  v.vendor_id,
  s.item_number
from staging_materials s
join materials m
  on trim(s.item_description) = m.item_description
join vendors v
  on trim(s.vendor) = v.vendor_name;
```

--bridge table data load - material_classes

```
insert into material_classes (material_id, class_id)
select distinct
  m.material_id,
  c.class_id
from staging_materials s
join materials m
  on s.item_description = m.item_description
join classes c
  on s.class_name = c.class_name;
```
