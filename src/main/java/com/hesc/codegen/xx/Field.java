package com.hesc.codegen.xx;

import lombok.Data;

@Data
public class Field {
    //字段名
    private String fieldName;
    //字段类型
    private String fieldType;
    //字段注释
    private String fieldRemarks;
    //字段名首字母大写
    private String fieldNameUpperFirstLetter;
}