package com.tqq.springboot.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.common.Result;
import com.tqq.springboot.entity.Course;
import com.tqq.springboot.service.ICourseService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
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
@RequestMapping("/course")
public class CourseController {

    @Resource
    private ICourseService courseService;

    // 新增或者更新
    @PostMapping
    public Result save(@RequestBody Course course) {

        return Result.success(courseService.saveOrUpdate(course));
    }
    @PostMapping("/studentCourse/{courseId}/{studentId}")
    public Result studentCourse(@PathVariable Integer courseId,@PathVariable Integer studentId) {
        courseService.setStudentCourse(courseId,studentId);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {

        return Result.success(courseService.removeById(id));
    }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {

        return Result.success(courseService.removeByIds(ids));
    }

    @GetMapping
    public Result findAll() {

        return Result.success(courseService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {

        return Result.success(courseService.getById(id));
    }

    @GetMapping("/page")
    public Result findPage(
            @RequestParam String name,@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {


        Page<Course> page = courseService.findPage(new Page<>(pageNum, pageSize),name);
        return Result.success();
    }

}

