package com.sist.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.sist.web.model.MainCate;
import com.sist.web.model.SubCate;
import com.sist.web.service.CateService;

@ControllerAdvice("cateAdvice")
public class CateAdvice {
    
    @Autowired
    private CateService cateService;

    @ModelAttribute("mainCateList")
    public List<MainCate> getMainCateList() {
        return cateService.mainCateList();
    }
    
    @ModelAttribute("subCateMap")
    public Map<String, List<SubCate>> getSubCateMap() {
        List<SubCate> subCateList = cateService.subCateList();
        Map<String, List<SubCate>> subCateMap = new HashMap<>();

        for (SubCate subCate : subCateList) {
            subCateMap
                .computeIfAbsent(subCate.getMainCateNum(), k -> new ArrayList<>())
                .add(subCate);
        }

        return subCateMap;
    }
}