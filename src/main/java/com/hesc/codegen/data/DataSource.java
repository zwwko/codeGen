package com.hesc.codegen.data;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DataSource {
    /**
     * 驱动
     */
    private String driverClass;
    /**
     * 数据库名称
     */
    private String dbName;
    /**
     * 密码
     */
    private String dbPassword;
    /**
     * 数据库类型
     */
    private String dbType;
    /**
     * URL
     */
    private String url;
    /**
     * 帐号
     */
    private String dbUser;
}