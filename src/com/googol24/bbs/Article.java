package com.googol24.bbs;

import java.util.Date;

public class Article {
    private int id;
    private int pid;
    private int rootId;
    private String title;
    private String cont;
    private Date pdate;
    // 0-Leaf，1-非Leaf
    private int isLeaf;
    private int level;

    public String getCont() {
        return cont;
    }

    public void setCont(String cont) {
        this.cont = cont;
    }

    public int getRootId() {
        return rootId;
    }

    public void setRootId(int rootId) {
        this.rootId = rootId;
    }

    public Article(int id, int pid, int rootId, String title, Date pDate, int isLeaf) {
        this.id = id;
        this.pid = pid;
        this.rootId = rootId;
        this.title = title;
        this.pdate = pDate;
        this.isLeaf = isLeaf;
    }

    public int getId() {
        return id;
    }

    public int getPid() { return pid; }

    public String getTitle() {
        return title;
    }

    public int getIsLeaf() {
        return isLeaf;
    }

    public Date getPdate() {
        return pdate;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    @Override
    public String toString(){
        return "";
    }
}
