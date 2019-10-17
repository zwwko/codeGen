package com.hesc.codegen.data;

import lombok.Data;

@Data
public class DbColumnInf {
    // 获得字段名称
    private String columnName;
    // 获得字段类型名称
    private String typeName;
    // 获得字段大小
    private String columnSize;
    // 获得字段备注
    private String remarks;
    // 是否为主键
    private boolean parmaryKey;
    // 是否为外键
    private boolean importedKey;
    // 是否允许为空
    private boolean nullable;
    // 默认值
    private String columnDef;
    // 小数部分的位数
    private String decimalDigits;

    public DbColumnInf(String columnName, String typeName, String columnSize, String remarks, boolean nullable,
                       boolean parmaryKey, boolean importedKey, String columnDef, String decimalDigits) {
        this.columnName = columnName;
        this.typeName = typeName;
        this.columnSize = columnSize;
        this.remarks = remarks;
        this.nullable = nullable;
        this.parmaryKey = parmaryKey;
        this.importedKey = importedKey;
        this.columnDef = columnDef;
        this.decimalDigits = decimalDigits;

    }
}
