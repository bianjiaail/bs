package com.tqq.springboot.controller;


import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.common.Result;
import com.tqq.springboot.entity.Student;
import com.tqq.springboot.service.IStudentService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author tqq
 * @since 2022-05-10
 */
@RestController
@RequestMapping("/studentInfo")
public class StudentController {

    @Resource
    private IStudentService studentService;

    // 新增或者更新
    @PostMapping
    public Result save(@RequestBody Student student) {

        return Result.success(studentService.saveOrUpdate(student));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {

        return Result.success(studentService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {

        return Result.success(studentService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {

        return Result.success(studentService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {

        return Result.success(studentService.getById(id));
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Student> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("id");

        return Result.success(studentService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }

    /**
     * 导出接口
     */
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws Exception {
        // 1.从数据库查询出所有的数据
        List<Student> list = studentService.list();
        //2. 在内存操作，写出到浏览器
        ExcelWriter writer = ExcelUtil.getWriter(true);
        //只导出设置了别名的字段
        writer.setOnlyAlias(true);
        // 3.一次性写出list内的对象到excel，使用默认样式，强制输出标题
        writer.write(list, true);

        // 设置浏览器响应的格式
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        String fileName = URLEncoder.encode("用户信息", "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");

        ServletOutputStream out = response.getOutputStream();
        writer.flush(out, true);
        out.close();
        writer.close();

    }

    /**
     * excel导入
     */
    @PostMapping("/import")
    public Boolean imp(MultipartFile file) throws Exception {
        InputStream inputStream = file.getInputStream();
        ExcelReader reader = ExcelUtil.getReader(inputStream);
        List<Student> list = reader.readAll(Student.class);
        studentService.saveBatch(list);
        return true;
    }

}

