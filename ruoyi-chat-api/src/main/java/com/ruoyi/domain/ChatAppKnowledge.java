package com.ruoyi.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * 应用和知识库关联对象 chat_app_knowledge
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public class ChatAppKnowledge extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private String id;

    /** 应用ID */
    @Excel(name = "应用ID")
    private String appId;

    /** 知识库主键 */
    @Excel(name = "知识库主键")
    private String knowledgeId;

    public void setId(String id) 
    {
        this.id = id;
    }

    public String getId() 
    {
        return id;
    }
    public void setAppId(String appId) 
    {
        this.appId = appId;
    }

    public String getAppId() 
    {
        return appId;
    }
    public void setKnowledgeId(String knowledgeId) 
    {
        this.knowledgeId = knowledgeId;
    }

    public String getKnowledgeId() 
    {
        return knowledgeId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("appId", getAppId())
            .append("knowledgeId", getKnowledgeId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
