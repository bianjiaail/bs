package com.tqq.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tqq.springboot.entity.Menu;

import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author tqq
 * @since 2022-05-04
 */
public interface IMenuService extends IService<Menu> {

    List<Menu> findMenus(String name);
}
