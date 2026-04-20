--Main tables
```
create table materials (
  material_id serial primary key,
  material_type text,
  item_description text,
  notes text
);
```

```
create table vendors(
  vendor_id serial primary key,
  vendor_name text unique
 );
```
```
create table classes (
  class_id serial primary key,
  class_name text unique
);
```

--bridge table - material_id, vendor_id, vendor_item_number
```
create table material_vendor_items (
  item_id serial primary key,
  material_id int references materials(material_id),
  vendor_id int references vendors(vendor_id),
  vendor_item_number text
);
```

--bridge table - material_id, class_id
```
create table material_classes (
  material_id int references materials(material_id),
  class_id int references classes(class_id),
  primary key (material_id, class_id)
);
```

-- Data staging before populating tables. To be used to unnest additional_classes into the classes table
```
create table staging_materials (
  material_type text,
  material_name text,
  item_description text,
  vendor_item_number text,
  vendor_name text,
  class_name text,
  url_link text,
  notes text,
  additional_classes text
);
```
