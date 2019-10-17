package com.hesc.codegen.xx;

import lombok.Data;

import java.util.List;

@Data
public class MyClass {
    //类名
    private String className;
    //字段的集合
    private List<Field> fieldList;
}