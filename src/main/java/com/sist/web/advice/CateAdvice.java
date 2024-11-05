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

    // 메인 카테고리 리스트
    @ModelAttribute("mainCateList")
    public List<MainCate> getMainCateList() {
        return cateService.mainCateList();
    }
    
    // 메인 카테고리에 해당하는 서브 카테고리 리스트 맵
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
    
    // 메인 카테고리 번호로 메인 카테고리 객체를 얻는 맵 (이름을 조회할 수 있음)
    @ModelAttribute("mainCateMap")
    public Map<String, MainCate> getMainCateMap() {
        List<MainCate> mainCateList = cateService.mainCateList();
        Map<String, MainCate> mainCateMap = new HashMap<>();

        for (MainCate mainCate : mainCateList) {
            mainCateMap.put(mainCate.getMainCateNum(), mainCate);
        }

        return mainCateMap;
    }
    
    // 서브 카테고리 번호로 서브 카테고리 객체를 얻는 맵 (이름을 조회할 수 있음)
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