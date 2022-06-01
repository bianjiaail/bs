package com.tqq.springboot.controller;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tqq.springboot.common.Result;
import com.tqq.springboot.entity.Files;
import com.tqq.springboot.mapper.FilesMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

/**
 * 文件上传下载相关接口
 *
 * @author tqq
 */
@RestController
@RequestMapping("/file")
public class FileController {

    @Value("${files.upload.path}")
    private String fileUploadPath;

    @Resource
    private FilesMapper filesMapper;


    /**
     * 文件上传
     *
     * @param file
     * @return String
     */
    @PostMapping("upload")
    public String upload(@RequestParam MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String type = FileUtil.extName(originalFilename);
        long size = file.getSize();

        //定义一个文件唯一的标识码
        String uuid = IdUtil.fastSimpleUUID();
        String fileUUID = uuid + StrUtil.DOT + type;

        File uploadFile = new File(fileUploadPath + fileUUID);
        //判断配置的文件目录是否存在，若不存在则创建一个新的文件目录
        File parentFile = uploadFile.getParentFile();
        if (!parentFile.exists()) {
            parentFile.mkdirs();
        }

        String md5;
        String url;
        //上传文件到磁盘
        file.transferTo(uploadFile);
        //获取文件的md5,通过对比md5避免重复上传相同内容的文件
        md5 = SecureUtil.md5(uploadFile);

        // 从数据库查询是否存在相同的记录
        Files dbFiles = getFileByMd5(md5);

        if (dbFiles != null) {
            url = dbFiles.getUrl();
            //删除最新上传的重复文件
            uploadFile.delete();
        } else {
            //数据库中不存在重复文件，则上传文件
            url = "http://localhost:8081/file/" + fileUUID;
        }


        //存储到数据库
        Files saveFile = new Files();
        saveFile.setName(originalFilename);
        saveFile.setType(type);
        saveFile.setSize(size / 1024);
        saveFile.setUrl(url);
        saveFile.setMd5(md5);
        filesMapper.insert(saveFile);
        return url;

    }

    /**
     * 文件下载  http://localhost:8081/file/{fileUUID}
     *
     * @param fileUUID
     * @param response
     */

    @GetMapping("/{fileUUID}")
    public void download(@PathVariable String fileUUID, HttpServletResponse response) throws IOException {
        //根据文件的唯一标识码获取文件
        File uploadFile = new File(fileUploadPath + fileUUID);
        // 设置输出流的格式
        ServletOutputStream os = response.getOutputStream();
        response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileUUID, "UTF-8"));
        response.setContentType("application/octet-stream");

        //读取文件字节流
        os.write(FileUtil.readBytes(uploadFile));
        os.flush();
        os.close();
    }

    /**
     * 通过文件的md5查询文件
     *
     * @param md5
     * @return Files
     */

    private Files getFileByMd5(String md5) {
        //查询文件的md5是否存在
        QueryWrapper<Files> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("md5", md5);
        List<Files> filesList = filesMapper.selectList(queryWrapper);
        return filesList.size() == 0 ? null : filesList.get(0);
    }

    /**
     * 根据id删除一个
     *
     * @param id
     * @return Result
     */

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        Files files = filesMapper.selectById(id);
        files.setIsDelete(true);
        filesMapper.updateById(files);
        return Result.success();
    }

    /**
     * 根据id批量删除
     *
     * @param ids
     * @return boolean
     */
    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        // select * from files where id in (id,id,id...)
        QueryWrapper<Files> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("id", ids);
        List<Files> files = filesMapper.selectList(queryWrapper);
        for (Files file : files) {
            file.setIsDelete(true);
            filesMapper.updateById(file);
        }

        return Result.success();
    }

    /**
     * 更新
     */
    @PostMapping("/update")
    public Result update(@RequestBody Files files) {
        return Result.success(filesMapper.updateById(files));
    }

    /**
     * 分页查询
     *
     * @param pageNum
     * @param pageSize
     * @param name
     * @return Result
     */

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum, @RequestParam Integer pageSize, @RequestParam(defaultValue = "") String name) {
        QueryWrapper<Files> queryWrapper = new QueryWrapper<>();
        //查询未删除记录
        queryWrapper.eq("is_delete", false);
        queryWrapper.orderByDesc("id");
        if (!"".equals(name)) {
            queryWrapper.like("name", name);
        }

        return Result.success(filesMapper.selectPage(new Page<>(pageNum, pageSize), queryWrapper));
    }
}



