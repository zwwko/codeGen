package com.hesc.codegen.data;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DbTableInf {
    private String tableName;
    private String remarks;
}
