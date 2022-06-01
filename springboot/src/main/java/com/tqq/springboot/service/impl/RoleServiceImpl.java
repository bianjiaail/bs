package com.tqq.springboot.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tqq.springboot.entity.Menu;
import com.tqq.springboot.entity.Role;
import com.tqq.springboot.entity.RoleMenu;
import com.tqq.springboot.mapper.RoleMapper;
import com.tqq.springboot.mapper.RoleMenuMapper;
import com.tqq.springboot.service.IMenuService;
import com.tqq.springboot.service.IRoleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author tqq
 * @since 2022-05-04
 */
@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    @Resource
    private RoleMenuMapper roleMenuMapper;

    @Resource
    private IMenuService menuService;

    @Transactional
    @Override
    public void setRoleMenu(Integer roleId, List<Integer> menuIds) {
        //先删除当前角色id绑定的所有关系
        roleMenuMapper.deleteByRoleId(roleId);

        //    再把前端传过来的菜单id数组绑定到当前角色id上
        List<Integer> menuIdsCopy = CollUtil.newArrayList(menuIds);
        for (Integer menuId : menuIds) {
            Menu menu = menuService.getById(menuId);
            //二级菜单 如果pid不为空并且传过来的菜单数组不存在他的父级id
            if (menu.getPid() != null && !menuIdsCopy.contains(menu.getPid())) {
                //补上二级菜单的父级id
                RoleMenu roleMenu = new RoleMenu();
                roleMenu.setRoleId(roleId);
                roleMenu.setMenuId(menu.getPid());
                roleMenuMapper.insert(roleMenu);
                menuIdsCopy.add(menu.getPid());
            }
            RoleMenu roleMenu = new RoleMenu();
            roleMenu.setRoleId(roleId);
            roleMenu.setMenuId(menuId);
            roleMenuMapper.insert(roleMenu);
        }
    }

    @Override
    public List<Integer> getRoleMenu(Integer roleId) {
        return roleMenuMapper.selectByRoleId(roleId);
    }
}
