package com.ruoyi.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * 知识库对象 chat_knowledge
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public class ChatKnowledge extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 知识库主键 */
    private String knowledgeId;

    /** 知识库名称 */
    @Excel(name = "知识库名称")
    private String knowledgeName;

    /** 知识库描述 */
    @Excel(name = "知识库描述")
    private String desc;

    /** 用户id */
    @Excel(name = "用户id")
    private Long userId;

    public void setKnowledgeId(String knowledgeId) 
    {
        this.knowledgeId = knowledgeId;
    }

    public String getKnowledgeId() 
    {
        return knowledgeId;
    }
    public void setKnowledgeName(String knowledgeName) 
    {
        this.knowledgeName = knowledgeName;
    }

    public String getKnowledgeName() 
    {
        return knowledgeName;
    }
    public void setDesc(String desc) 
    {
        this.desc = desc;
    }

    public String getDesc() 
    {
        return desc;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("knowledgeId", getKnowledgeId())
            .append("knowledgeName", getKnowledgeName())
            .append("desc", getDesc())
            .append("userId", getUserId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
