
package com.dayWise.dao;

import java.util.Map;

public interface AnalyticsDAO {

    /**
     * Retrieves summary cards and chart data for one user.
     */
    Map<String, Object> getAnalyticsData(long userId);
}
