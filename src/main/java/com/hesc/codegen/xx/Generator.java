package com.hesc.codegen.xx;

import freemarker.template.Configuration;
import freemarker.template.Template;
 
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;
 
public class Generator {

    public static void main(String[] args) throws Exception {
        //创建Configuration对象
        Configuration configuration = new Configuration();
        //设置模板所在目录
        String path = Generator.class.getClassLoader().getResource("module").getPath();
        configuration.setDirectoryForTemplateLoading(new File(path));
        //获取模板
        Template template = configuration.getTemplate("class.ftl");
        //设置数据并执行
        Map map = new HashMap();

        ClassGenerator classGenerator = new ClassGenerator();
        MyClass myClass = classGenerator.generateClass("user");

        map.put("myClass", myClass);

        Writer writer = new OutputStreamWriter(new FileOutputStream("G:/" + myClass.getClassName() + ".java"));

        template.process(map, writer);
    }
}