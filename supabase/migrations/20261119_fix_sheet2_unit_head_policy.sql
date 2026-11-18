drop policy if exists manpower_analysis_rows_upd on public.manpower_analysis_rows;
create policy manpower_analysis_rows_upd on public.manpower_analysis_rows
  for update to authenticated
  using (
    my_role() = 'admin'
    or (
      my_role() = 'unit_head'
      and (
        my_unit() = '*'
        or my_unit() = group_name
        or my_unit() = scope_unit
        or exists (
          select 1
          from public.manpower_targets t
          where t.group_name = manpower_analysis_rows.group_name
            and t.unit_name = my_unit()
        )
      )
    )
  )
  with check (
    my_role() = 'admin'
    or (
      my_role() = 'unit_head'
      and (
        my_unit() = '*'
        or my_unit() = group_name
        or my_unit() = scope_unit
        or exists (
          select 1
          from public.manpower_targets t
          where t.group_name = manpower_analysis_rows.group_name
            and t.unit_name = my_unit()
        )
      )
    )
  );
