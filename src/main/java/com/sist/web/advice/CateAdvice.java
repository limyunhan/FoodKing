package com.sist.web.advice;

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

@ControllerAdvice
public class CateAdvice {
    
    @Autowired
    private CateService cateService;

    @ModelAttribute("mainCateList")
    public List<MainCate> getMainCateList() {
        return cateService.mainCateList();
    }
    
    @ModelAttribute("subCateListMap") 
    public Map<String, List<SubCate>> getSubCateListMap() {
        List<SubCate> subCateList = cateService.subCateList();
        Map<String, List<SubCate>> subCateListMap = new HashMap<>();

        for (SubCate subCate : subCateList) {
            subCateListMap
                .computeIfAbsent(subCate.getMainCateNum(), k -> new ArrayList<>())
                .add(subCate);
        }

        return subCateListMap;
    }
    
    @ModelAttribute("mainCateMap")
    public Map<String, MainCate> getMainCateMap() {
        List<MainCate> mainCateList = cateService.mainCateList();
        Map<String, MainCate> mainCateMap = new HashMap<>();

        for (MainCate mainCate : mainCateList) {
            mainCateMap.put(mainCate.getMainCateNum(), mainCate);
        }

        return mainCateMap;
    }
    
    @ModelAttribute("subCateMap") 
    public Map<String, SubCate> getSubCateMap() {
        List<SubCate> subCateList = cateService.subCateList();
        Map<String, SubCate> subCateMap = new HashMap<>();

        for (SubCate subCate : subCateList) {
            subCateMap.put(subCate.getSubCateCombinedNum(), subCate);
        }

        return subCateMap;
    }
}