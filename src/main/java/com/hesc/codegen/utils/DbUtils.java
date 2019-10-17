package com.hesc.codegen.utils;

import lombok.Data;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import java.util.List;
import java.util.Map;

/**
 * 使用Freemarker生成jsp文件
 */
public class DbUtils {
    private JdbcTemplate jdbcTemplate;
    private JdbcTemplate getJdbcTemplate(){
        if(null==jdbcTemplate){
            init();
        }
        return jdbcTemplate;
    }

    private void init(){
        DriverManagerDataSource dataSource=new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://192.168.86.99:9306/sifa_supervisorms_2019?useUnicode=true&characterEncoding=utf-8&tinyInt1isBit=false");
        dataSource.setUsername("root");
        dataSource.setPassword("123456");
        jdbcTemplate=new JdbcTemplate(dataSource);
    }



    public void test(String tableName) {
        String tableComentSql = "select t.TABLE_NAME,t.TABLE_COMMENT from information_schema.TABLES t where t.table_name = ?";
        String descSql = "select t.COLUMN_NAME as columnName,t.COLUMN_DEFAULT as columnDefault,t.COLUMN_KEY as columnKey," +
                "t.IS_NULLABLE as isNullable,t.DATA_TYPE as dataType,t.COLUMN_TYPE as columnType,t.COLUMN_COMMENT as columnComment" +
                "from information_schema.columns t where t.table_name = 'supervisor_activity' ORDER BY t.ORDINAL_POSITION;";
        Map map = getJdbcTemplate().queryForMap(tableComentSql,tableName);
        List<Map<String, Object>> list = getJdbcTemplate().queryForList(descSql,tableName);

        System.out.println(list);
    }

    @Data
    class column{
        private String tableName;
        private String tableComment;
        private String columnName;
        private String columnDefault;
        private String columnKey;
        private String isNullable;
        private String dataType;
        private String columnType;
        private String columnComment;
    }

    public static void main(String[] args) throws Exception {

    }

}