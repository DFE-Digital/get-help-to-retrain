select a.variant_skill_id   as skill_a_id
      ,a.variant_skill_name as skill_a_name
      ,b.variant_skill_id   as skill_b_id
      ,b.variant_skill_name as skill_b_name
      ,a.master_skill_name  as master_skill_name
from   skills_plus_variants a
inner join skills_plus_variants b on a.master_skill_name = b.master_skill_name