package com.hesc.codegen.utils;

import com.hesc.codegen.data.DataSource;
import com.hesc.codegen.data.DbColumnInf;
import com.hesc.codegen.data.DbHelper;
import com.hesc.codegen.data.DbTableInf;
import org.beetl.core.Configuration;
import org.beetl.core.GroupTemplate;
import org.beetl.core.Template;
import org.beetl.core.resource.StringTemplateResourceLoader;
import org.springframework.util.FileCopyUtils;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * beetle生成jsp文件
 */
public class Generator {
    public static void main(String[] args) throws Exception {
        String moduleName = "activity";
        String tableName = "supervisor_activity";
        String redirect = "supervisor/activity/sifa";

        List<String> columnInfForm = Arrays.asList("hdfqdwmc,yqrs,hdlx,hdfqsj,hdsj,hddd,hdmc,hdnr".split(","));//新增,编辑
        List<String> columnInfQuery = Arrays.asList("hdmc,hdlx".split(","));//查询
        List<String> columnInfList = Arrays.asList("hdmc,hdlx,hdsj,hddd,yqrs,hdfqdwmc,hdzt".split(","));//列表

        execute(moduleName, tableName, columnInfForm, redirect, columnInfQuery, columnInfList);
    }


    public static void execute(String moduleName, String tableName, List<String> columnFormKeys, String redirect, List<String> columnsQueryKeys, List<String> columnsListKeys) throws Exception {
        DbHelper dbHelper = new DbHelper();
        dbHelper.initConnection(DataSource.builder()
                .dbType("MYSQL")
                .driverClass("com.mysql.jdbc.Driver")
                .url("jdbc:mysql://192.168.86.99:9306/sifa_supervisorms_2019?useSSL=false&useUnicode=true&characterEncoding=utf-8&tinyInt1isBit=false&serverTimezone=GMT%2B8")
                .dbUser("root")
                .dbPassword("123456")
                .build());

//        String moduleName = "activity";
//        String tableName = "supervisor_activity";
//        String redirect = "supervisor/kaohejx/kaohe";
        String entityName = StringUtils.underlineToCamel(tableName);

//        List<String> formColumns = Arrays.asList(new String[]{"hdmc", "hdfqsj"});//新增,编辑
//        List<String> queryColumns = Arrays.asList(new String[]{"hdmc", "hdfqsj"});//查询
//        List<String> listColumns = Arrays.asList(new String[]{});//列表


        //驼峰命名
        columnFormKeys.forEach(StringUtils::underlineToCamel);
        columnsQueryKeys.forEach(StringUtils::underlineToCamel);
        columnsListKeys.forEach(StringUtils::underlineToCamel);

        //当前表信息
//        List<DbTableInf> listDbTableInf = dbHelper.getDbTables();
//        DbTableInf tableInf = listDbTableInf.stream().filter(obj -> obj.getTableName().equals(tableName)).collect(Collectors.toList()).get(0);
//        DbTableInf tableInf = new DbTableInf(tableName, "");
        DbTableInf tableInf = dbHelper.getDbTableInf(tableName);

        List<DbColumnInf> columnInfs = dbHelper.getDbColumnInfo(tableInf.getTableName());
        columnInfs.forEach(obj -> obj.setColumnName(StringUtils.underlineToCamel(obj.getColumnName())));
        Map<String, DbColumnInf> columnInfMap = columnInfs.stream().collect(Collectors.toMap(DbColumnInf::getColumnName,v->v));

        System.out.println(columnInfMap.keySet());


        List<DbColumnInf> columnInfForm = columnFormKeys.stream().map(key->columnInfMap.get(key)).collect(Collectors.toList());
        List<DbColumnInf> columnInfQuery = columnsQueryKeys.stream().map(key->columnInfMap.get(key)).collect(Collectors.toList());;
        List<DbColumnInf> columnInfList = columnsListKeys.isEmpty()?columnInfs:columnsListKeys.stream().map(key->columnInfMap.get(key)).collect(Collectors.toList());


        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("moduleName", moduleName);
        paramMap.put("entityName", entityName);
        paramMap.put("redirect", redirect);
        paramMap.put("tableInf", tableInf);
        paramMap.put("columnInfForm", columnInfForm);
        paramMap.put("columnInfQuery", columnInfQuery);
        paramMap.put("columnInfList", columnInfList);


        generateJsp("add.jsp", paramMap);
        generateJsp("edit.jsp", paramMap);
        generateJsp("list.jsp", paramMap);
//        generateJsp("test.html", paramMap);


        dbHelper.closeConnection();
    }

    /**
     * 根据模板生成jsp文件
     *
     * @param templateName 模板名称
     * @param paramMap     模板参数
     */
    public static void generateJsp(String templateName, Map<String, Object> paramMap) throws Exception {
        File template = new File(Configuration.class.getClassLoader().getResource("template").getPath(), templateName);// html文件

        StringTemplateResourceLoader resourceLoader = new StringTemplateResourceLoader();
        Configuration cfg = Configuration.defaultConfiguration();

        GroupTemplate gt = new GroupTemplate(resourceLoader, cfg);
        String templateString = FileCopyUtils.copyToString(new FileReader(template));
        Template t = gt.getTemplate(templateString);
        t.binding(paramMap);
        String str = t.render();

        File jsp = new File(Configuration.class.getClassLoader().getResource("jsp").getPath(), templateName);// jsp
        if (jsp.exists()) {
            jsp.delete();
            System.out.println("文件已存在时删除原有文件");
        }
        FileCopyUtils.copy(str, new FileWriter(jsp));
    }

}