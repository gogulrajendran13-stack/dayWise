
package com.dayWise.model;

import java.sql.Timestamp;

/**
 * Represents a task category in the dayWise application.
 * Maps to the categories table in daywise_db.
 */
public class Category {

    private long categoryId;
    private long userId;
    private String categoryName;
    private String categoryColor;
    private Timestamp createdAt;

    public Category() {
    }

    public Category(long userId, String categoryName,
                    String categoryColor) {
        this.userId = userId;
        this.categoryName = categoryName;
        this.categoryColor = categoryColor;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryColor() {
        return categoryColor;
    }

    public void setCategoryColor(String categoryColor) {
        this.categoryColor = categoryColor;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
