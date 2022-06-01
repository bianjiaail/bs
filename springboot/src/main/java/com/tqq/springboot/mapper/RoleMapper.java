package com.tqq.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tqq.springboot.entity.Role;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author tqq
 * @since 2022-05-04
 */
public interface RoleMapper extends BaseMapper<Role> {
    @Select("select id from role where flag = #{flag} ")
    Integer selectByFlag(@Param("flag") String role);
}
