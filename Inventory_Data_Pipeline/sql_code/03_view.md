-- View: vw_materials_details  
-- Purpose: Provides a flattened, analysis-ready dataset for inventory lookup and reporting  
-- Combines materials, classes, and vendor information into a single view  
-- Designed for use in Tableau dashboard for filtering, search, and item-level detail display  
-- Note: This view intentionally returns multiple rows per material when associated with multiple  
-- classes and/or vendors. This denormalized structure supports flexible filtering and selection  
-- within the dashboard.
```
create view vw_materials_details as
select
  m.material_id,
  m.material_name,
  m.material_type,
  m.item_description,
  c.class_name,
  v.vendor_name,
  mvi.vendor_item_number,
  m.url_link,
  m.notes
from materials m
join material_classes mc
  on m.material_id = mc.material_id
join classes c
  on mc.class_id = c.class_id
left join material_vendor_items mvi
  on m.material_id = mvi.material_id
left join vendors v
  on mvi.vendor_id = v.vendor_id;
```
