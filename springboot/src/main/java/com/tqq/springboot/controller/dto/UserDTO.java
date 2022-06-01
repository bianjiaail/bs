package com.tqq.springboot.controller.dto;

import com.tqq.springboot.entity.Menu;
import lombok.Data;

import java.util.List;

/**
 * 接收前端登录请求的参数
 *
 * @author tqq
 */
@Data
public class UserDTO {
    private Integer id;
    private String username;
    private String password;
    private String realname;
    private String avatarUrl;
    private String token;
    private String role;
    private List<Menu> menus;
}
