package com.tqq.springboot.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.entity.Course;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author tqq
 * @since 2022-05-10
 */
public interface CourseMapper extends BaseMapper<Course> {
    Page<Course> findPage(Page<Course> page, @Param("name") String name);

    void deleteStudentCourse(@Param("courseId") Integer courseId, @Param("studentId") Integer studentId);

    void setStudentCourse(@Param("courseId") Integer courseId, @Param("studentId") Integer studentId);

}
