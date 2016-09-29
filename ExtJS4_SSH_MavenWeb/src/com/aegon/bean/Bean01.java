package com.aegon.bean;

public class Bean01 {
	
	private String name = "";
	
	public Bean01(){
		System.out.println("我是Bean01,我被initial...");
	}
	
	public void setName(String name){
		this.name = name;
	}

	public String getName(){
		return name;
	}
}
