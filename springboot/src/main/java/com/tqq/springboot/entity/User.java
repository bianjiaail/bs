package com.tqq.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * <p>
 * 用户信息表
 * </p>
 *
 * @author tqq
 */
@Data
@ApiModel(value = "User对象", description = "用户信息表")
@ToString
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty("用户名 工号")
    @Alias("用户名")
    private String username;

    @ApiModelProperty("密码")
    @Alias("密码")
    private String password;

    @ApiModelProperty("姓名")
    @Alias("姓名")
    private String realname;

    @ApiModelProperty("邮箱")
    @Alias("邮箱")
    private String email;

    @ApiModelProperty("电话")
    @Alias("电话")
    private String phone;

    @ApiModelProperty("地址")
    @Alias("地址")
    private String address;

    @ApiModelProperty("头像")
    private String avatarUrl;

    @ApiModelProperty("角色")
    @Alias("角色")
    private String role;

    @TableField(exist = false)
    private List<Course> courses;

    @TableField(exist = false)
    private List<Course> stuCourses;


}
