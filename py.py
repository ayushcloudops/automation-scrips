import pandas

pandas.concat([pandas.read_excel('ng_capacity.xlsx', sheet_name=None),
            pandas.read_excel('status_codes.xlsx', sheet_name=None)], axis=1).to_excel('merged.xlsx', index=False)