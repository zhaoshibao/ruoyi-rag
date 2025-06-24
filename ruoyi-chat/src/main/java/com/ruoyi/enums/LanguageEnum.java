package com.ruoyi.enums;

public enum LanguageEnum {
    CHINESE(0, "请说中文"),
    ENGLISH(1, "请说英文"),
    ;
    private Integer type;
    private String msg;

    LanguageEnum(Integer type, String msg) {
        this.type = type;
        this.msg = msg;
    }

    public static String getMsg(Integer type){
        LanguageEnum[] values = LanguageEnum.values();
        for (LanguageEnum value : values) {
            if(value.type.equals(type)){
                return value.msg;
            }
        }
        return null;
    }
}
