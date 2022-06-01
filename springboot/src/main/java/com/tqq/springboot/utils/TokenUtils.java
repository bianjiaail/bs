package com.tqq.springboot.utils;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.tqq.springboot.entity.User;
import com.tqq.springboot.service.IUserService;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * JWT 生成token
 *
 * @author tqq
 */
public class TokenUtils {
    private static IUserService staticUserService;
    @Resource
    private IUserService userService;

    public static String getToken(String userId, String sign) {
        return JWT.create().withAudience(userId)  // 将 userid 保存到 token 里面，作为载荷
                .withExpiresAt(DateUtil.offsetHour(new Date(), 2))  // 2小时后 token 过期
                .sign(Algorithm.HMAC256(sign)); // 以 password 作为 token 密码

    }

    /**
     * 获取当前登录的用户信息
     *
     * @return user对象
     */
    public static User getCurrentUser() {
        try {
            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            String token = request.getHeader("token");
            if (StrUtil.isNotBlank(token)) {
                String userId = JWT.decode(token).getAudience().get(0);
                return staticUserService.getById(Integer.valueOf(userId));
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }

    @PostConstruct
    public void setUserService() {
        staticUserService = userService;
    }
}
