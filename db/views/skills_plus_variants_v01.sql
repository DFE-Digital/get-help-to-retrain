select skl.id                         as variant_skill_id,
       skl.name                       as variant_skill_name,
       COALESCE(skv.master_name, skl.name) as master_skill_name
 from skills skl
   left outer join skills skv on skl.name = skv.name
