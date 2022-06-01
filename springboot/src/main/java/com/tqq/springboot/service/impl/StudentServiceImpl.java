package com.tqq.springboot.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tqq.springboot.entity.Student;
import com.tqq.springboot.mapper.StudentMapper;
import com.tqq.springboot.service.IStudentService;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author tqq
 * @since 2022-05-10
 */
@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements IStudentService {

}
