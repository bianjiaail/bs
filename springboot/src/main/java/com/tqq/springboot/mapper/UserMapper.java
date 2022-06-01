package com.tqq.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.controller.dto.UserPasswordDTO;
import com.tqq.springboot.entity.User;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

/**
 * <p>
 * 用户信息表 Mapper 接口
 * </p>
 *
 * @author tqq
 * @since 2022-04-30
 */
public interface UserMapper extends BaseMapper<User> {

    @Update("update user set password = #{newPassword} where username = #{username} and password = #{password}")
    int updatePassword(UserPasswordDTO userPasswordDTO);

    Page<User> findPage(Page<User> page, @Param("username") String username, @Param("email")String email, @Param("address")String address);
}
