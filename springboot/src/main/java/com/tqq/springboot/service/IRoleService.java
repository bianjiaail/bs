package com.tqq.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tqq.springboot.entity.Role;

import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author tqq
 * @since 2022-05-04
 */
public interface IRoleService extends IService<Role> {

    void setRoleMenu(Integer roleId, List<Integer> menuIds);

    List<Integer> getRoleMenu(Integer roleId);
}
