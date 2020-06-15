select skl.id                         as variant_skill_id
       ,skl.name                       as variant_skill_name
       ,coalesce(skv.master_name, skl.name) as master_skill_name
from skills skl
left outer join skill_variants skv on skl.name = skv.variant_name
