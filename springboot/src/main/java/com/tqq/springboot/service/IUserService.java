package com.tqq.springboot.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.tqq.springboot.controller.dto.UserDTO;
import com.tqq.springboot.controller.dto.UserPasswordDTO;
import com.tqq.springboot.entity.User;

/**
 * <p>
 * 用户信息表 服务类
 * </p>
 *
 * @author tqq
 * @since 2022-04-30
 */
public interface IUserService extends IService<User> {

    /**
     * 登录
     *
     * @param userDTO
     * @return boolean
     */
    UserDTO login(UserDTO userDTO);

    void updatePassword(UserPasswordDTO userPasswordDTO);

    Page<User> findPage(Page<User> objectPage,String username,String email,String address);
}
