package com.aegon.ut;

import java.sql.Connection;

import com.aegon.util.DbFactory;

public class TestDbFacotryImpl {

	public static void main(String[] args) {
		
		Connection conn = DbFactory.getConnection();

	}

}
