package com.hesc.codegen.data;

import lombok.Data;
import org.springframework.util.StringUtils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * @description: 数据工具类
 */
@Data
public class DbHelper {

    private Connection connection;
    private String dbType;
    private String dbName;

    public Connection initConnection(DataSource dataSource) {
        try {
            Connection conn;
            String dbType = dataSource.getDbType();
            String url = dataSource.getUrl();
            String username = dataSource.getDbUser();
            String password = dataSource.getDbPassword();
            String driverClassName = dataSource.getDriverClass();
            Properties props = new Properties();
            if (username != null) {
                props.put("user", username);
            }
            if (password != null) {
                props.put("password", password);
            }
            if (dbType.equals("oracle")) {
                props.put("remarksReporting", "true");
            }
            // 初始化JDBC驱动并让驱动加载到jvm中
            Class.forName(driverClassName);
            conn = DriverManager.getConnection(url, props);
            conn.setAutoCommit(true);
            connection = conn;
            return conn;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    public List<DbTableInf> getDbTables() {
        ResultSet resultSet = null;
        List<DbTableInf> dbTableInfos = new ArrayList<>();
        try {
            getConnection().setAutoCommit(true);
            String[] types = {"TABLE"};
            // 判断是否为MYSQL
            String driverName = getConnection().getMetaData().getDriverName().toUpperCase();
            if (driverName.contains("ORACLE")) {
                resultSet = getConnection().getMetaData().getTables(null, dbName.toUpperCase(),
                        null, types);
            } else {
                resultSet = getConnection().getMetaData().getTables(null, null, null, types);
            }
            while (resultSet.next()) {
                String tableName = resultSet.getString("TABLE_NAME");
                String remarks = resultSet.getString("REMARKS");
                if (StringUtils.isEmpty(remarks)) {

                    if (driverName.contains("MySQL")) {
                        // String schemas = getCatalog(connection);
                        // remarks = getTableComment("jeeweb", tableName,
                        // connection);
                    }
                }
                DbTableInf dbTableInfo = new DbTableInf(tableName,remarks);
                dbTableInfos.add(dbTableInfo);
            }
        } catch (Exception e1) {
            if (connection != null)
                try {
                    getConnection().close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
        } finally {
            if (resultSet != null)
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
        }
        return dbTableInfos;
    }

    public List<DbColumnInf> getDbColumnInfo(String tableName) {
        ResultSet resultSet = null;
        List<DbColumnInf> columnInfos = new ArrayList<DbColumnInf>();
        try {
            getConnection().setAutoCommit(true);
            // 判断是否为MYSQL
            String driverName = getConnection().getMetaData().getDriverName().toUpperCase();
            // 获得列的信息
            resultSet = getConnection().getMetaData().getColumns(null, null, tableName, null);
            while (resultSet.next()) {
                // 获得字段名称
                String columnName = resultSet.getString("COLUMN_NAME");
                // 获得字段类型名称
                String typeName = resultSet.getString("TYPE_NAME").toUpperCase();
                // 获得字段大小
                String columnSize = resultSet.getString("COLUMN_SIZE");
                // 获得字段备注
                String remarks = resultSet.getString("REMARKS");
                if (!StringUtils.isEmpty(remarks)) {
                    remarks = remarks.replace("'", "");
                } else {
                    remarks = "";
                }

                // 该列是否为空
                Boolean nullable = Boolean.FALSE;
                if (driverName.contains("ORACLE")) {
                    nullable = resultSet.getBoolean("NULLABLE");
                } else {
                    nullable = "YES".equals(resultSet.getString("IS_NULLABLE"));
                }
                // 小数部分的位数
                String decimalDigits = resultSet.getString("DECIMAL_DIGITS");
                // 默认值
                String columnDef = resultSet.getString("COLUMN_DEF");
                if (!StringUtils.isEmpty(columnDef)) {
                    columnDef = columnDef.replace("'", "");
                    columnDef = columnDef.trim();
                }
                DbColumnInf info = new DbColumnInf(columnName, typeName, columnSize, remarks, nullable, false, false,
                        columnDef, decimalDigits);
                columnInfos.add(info);
            }

            // 获得主键的信息
            resultSet = getConnection().getMetaData().getPrimaryKeys(null, null, tableName);
            while (resultSet.next()) {
                String primaryKey = resultSet.getString("COLUMN_NAME");
                // 设置是否为主键
                for (DbColumnInf dbColumnInfo : columnInfos) {
                    if (primaryKey != null && primaryKey.equals(dbColumnInfo.getColumnName()))
                        dbColumnInfo.setParmaryKey(true);
                    else
                        dbColumnInfo.setParmaryKey(false);
                }
            }

            // 获得外键信息
            resultSet = getConnection().getMetaData().getImportedKeys(null, null, tableName);
            while (resultSet.next()) {
                String exportedKey = resultSet.getString("FKCOLUMN_NAME");
                // 设置是否是外键
                for (DbColumnInf dbColumnInfo : columnInfos) {
                    if (exportedKey != null && exportedKey.equals(dbColumnInfo.getColumnName()))
                        dbColumnInfo.setImportedKey(true);
                    else
                        dbColumnInfo.setImportedKey(false);
                }
            }

        } catch (Exception e1) {
            if (connection != null)
                try {
                    getConnection().close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
        } finally {
            if (resultSet != null)
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
        }
        return columnInfos;
    }


    public void closeConnection() {
        if (connection != null)
            try {
                getConnection().close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
    }

}

