
package com.mossle.student;

import java.util.List;

public class Page {
    private int totalCount;
    private List result;

    public Page(int totalCount, List result) {
        this.totalCount = totalCount;
        this.result = result;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public List getResult() {
        return result;
    }

    public String toString() {
    	//System.out.println("{totalCount:" + totalCount + ",result:" + result + "}");
        return "{totalCount:" + totalCount + ",result:" + result + "}";
    }
}
