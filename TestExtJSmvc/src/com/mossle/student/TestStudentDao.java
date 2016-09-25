package com.mossle.student;

import java.util.ArrayList;

public class TestStudentDao {

	public static void main(String[] args) {
		StudentDao sd = new StudentDao();
		try {
			Page page = sd.pagedQuery(0, 10, null, null);
			ArrayList al = (ArrayList) page.getResult();
			for(int i=0; i<al.size(); i++){
				Student student = (Student)al.get(i);
				System.out.println(student.getName());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
