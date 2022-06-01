package com.tqq.springboot.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tqq.springboot.entity.Course;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author tqq
 * @since 2022-05-10
 */
public interface ICourseService extends IService<Course> {

    Page<Course> findPage(Page<Course> page,String name);

    void setStudentCourse(Integer courseId, Integer studentId);
}
