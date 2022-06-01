package com.tqq.springboot.entity;

import cn.hutool.core.annotation.Alias;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 *
 * </p>
 *
 * @author tqq
 * @since 2022-05-10
 */
@Data
@TableName("student_extension")
@ApiModel(value = "StudentExtension对象", description = "")
@ToString
public class Student implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty("学号")
    @Alias("学号")
    private String sno;

    @ApiModelProperty("学生姓名")
    @Alias("学生姓名")
    private String sname;

    @ApiModelProperty("父亲姓名")
    @Alias("父亲姓名")
    private String sFather;

    @ApiModelProperty("母亲姓名")
    @Alias("母亲姓名")
    private String sMother;

    @ApiModelProperty("家长联系方式1")
    @Alias("家长联系方式1")
    private String telephone1;

    @ApiModelProperty("家长联系方式2")
    @Alias("家长联系方式2")
    private String telephone2;

    @ApiModelProperty("户籍地址")
    @Alias("户籍地址")
    private String address;

    @ApiModelProperty("班级编号")
    @Alias("班级编号")
    private Integer cid;

    @ApiModelProperty("创建时间")
    private LocalDateTime createTime;

    @ApiModelProperty("修改时间")
    private LocalDateTime updateTime;


}
