package com.tqq.springboot.controller;


import cn.hutool.core.util.StrUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.common.Constants;
import com.tqq.springboot.common.Result;
import com.tqq.springboot.controller.dto.UserDTO;
import com.tqq.springboot.controller.dto.UserPasswordDTO;
import com.tqq.springboot.entity.User;
import com.tqq.springboot.service.IUserService;
import com.tqq.springboot.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;

/**
 * <p>
 * 用户信息表 前端控制器
 * </p>
 *
 * @author tqq
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private IUserService userService;

    /**
     * 登录
     *
     * @param userDTO
     */

    @PostMapping("/login")
    public Result login(@RequestBody UserDTO userDTO) {
        String username = userDTO.getUsername();
        String password = userDTO.getPassword();
        if (StrUtil.isBlank(username) || StrUtil.isBlank(password)) {
            return Result.error(Constants.CODE_400, "参数错误");
        }
        UserDTO dto = userService.login(userDTO);
        return Result.success(dto);
    }

    /**
     * 修改密码
     */
    @PostMapping("/password")
    public Result password(@RequestBody UserPasswordDTO userPasswordDTO) {
        userService.updatePassword(userPasswordDTO);
        return Result.success();
    }

    /**
     * 新增或更新
     */
    @PostMapping
    public Result save(@RequestBody User user) {
        return Result.success(userService.saveOrUpdate(user));
    }

    @GetMapping("/role/{role}")
    public Result findUsersByRole(@PathVariable String role) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role", role);
        List<User> list = userService.list(queryWrapper);
        return Result.success(list);
    }

    /**
     * 根据id删除用户
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        return Result.success(userService.removeById(id));
    }

    /**
     * 根据id批量删除
     */
    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(userService.removeByIds(ids));
    }

    /**
     * 获取所有用户信息
     */
    @GetMapping
    public Result findAll() {
        return Result.success(userService.list());
    }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(userService.getById(id));
    }

    @GetMapping("/username/{username}")
    public Result findByUsername(@PathVariable String username) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        return Result.success(userService.getOne(queryWrapper));
    }

    /**
     * mybatis-plus 分页查询
     *
     * @param pageNum
     * @param pageSize
     * @param username
     * @param realname
     * @return Result
     */

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum, @RequestParam Integer pageSize, @RequestParam(defaultValue = "") String username, @RequestParam(defaultValue = "") String realname) {

        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        if (!"".equals(username)) {
            queryWrapper.like("username", username);
        }
        if (!"".equals(realname)) {
            queryWrapper.like("realname", realname);
        }
        ////获取当前用户信息
        //User currentUser = TokenUtils.getCurrentUser();
        //System.out.println(currentUser);

        return Result.success(userService.page(new Page<>(pageNum, pageSize), queryWrapper));
    }


    /**
     * excel导出
     */
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws Exception {
        // 1.从数据库查询出所有的数据
        List<User> list = userService.list();
        // 通过工具类创建writer 写出到磁盘路径
        //ExcelWriter writer = ExcelUtil.getWriter(filesUploadPath + "/用户信息.xlsx");
        //2. 在内存操作，写出到浏览器
        ExcelWriter writer = ExcelUtil.getWriter(true);
        //3.自定义标题别名
        //writer.addHeaderAlias("username", "用户名");
        //writer.addHeaderAlias("password", "密码");
        //writer.addHeaderAlias("realname", "姓名");
        //writer.addHeaderAlias("email", "邮箱");
        //writer.addHeaderAlias("phone", "电话");
        //writer.addHeaderAlias("address", "地址");
        //writer.addHeaderAlias("avatarUrl", "头像");
        //writer.addHeaderAlias("role", "角色");

        // 默认的，未添加alias的属性也会写出，如果想只写出加了别名的字段，可以调用此方法排除之
        writer.setOnlyAlias(true);
        // 4.一次性写出list内的对象到excel，使用默认样式，强制输出标题
        writer.write(list, true);

        // 设置浏览器响应的格式
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        String fileName = URLEncoder.encode("用户信息", "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xlsx");

        ServletOutputStream out = response.getOutputStream();
        writer.flush(out, true);
        out.close();
        writer.close();

    }

    /**
     * excel导入
     */
    @PostMapping("/import")
    public Boolean imp(MultipartFile file) throws Exception {
        InputStream inputStream = file.getInputStream();
        ExcelReader reader = ExcelUtil.getReader(inputStream);
        //导出数据模板为中文表头，无法导入数据(直接在实体使用@Alias设置中文别名）
        List<User> list = reader.readAll(User.class);
        //System.out.println(list);
        userService.saveBatch(list);
        return true;
    }


}

