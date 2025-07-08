package com.ruoyi.enums;

public enum ListSortEnum {

    ASC("asc", "正序"),
    DESC("desc", "倒序");

    public final String type;
    public final String value;

    ListSortEnum(String type, String value) {
        this.type = type;
        this.value = value;
    }

}
