{{ config(severity='warn') }}

-- The first 3 digits of a ZIP code identify the state: the test fails for every
-- user whose ZIP prefix is not in any range of their state
select
    u.user_id,
    u.state,
    u.zip_code
from {{ ref('stg_users') }} u
where not exists (
    select 1
    from {{ ref('zip_prefixes') }} z
    where z.state = u.state
      and cast(left(u.zip_code, 3) as integer) between z.zip3_min and z.zip3_max
)
