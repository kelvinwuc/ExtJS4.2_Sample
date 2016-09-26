package com.aegon.security;

import java.io.PrintStream;
import java.sql.Connection;
import java.util.Random;

/*
 * System   : AegonWeb
 * 
 * Function : 字串加解密公用程式
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : Disen Chen
 * 
 * Create Date : 2004/9/10
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: Security.java,v $
 * Revision 1.1  2006/06/29 09:40:39  MISangel
 * Init Project
 *
 * Revision 1.1.2.1  2004/12/17 10:10:51  MISELSA
 * R30530--Finance System
 *
 * Revision 1.2  2004/09/10 11:05:42  MISDISEN
 * (M40019)字串加解密公用程式
 *
 *  
 */
/**
 * 字串加解密公用程式
 * <p>
 * Example:<br>
 * 加密:<br>
 * String clearString = "abcde";<br>
 * String encryptString = Security.encrypt(clearString) ;<br>
 * <p>
 * 解密:<br>
 * String encryptString = "-z1b34=AA}7";<br>
 * String clearSting = Security.decrypt(encryptString);<br>
 * <p>
 * @author Disen Chen (2004/7/16)
 */
public class Security {

    /**
     * 不需產生 instance
     */
    private Security() {
    }

    /**
     * 字串加密
     * 
     * @param strToEncrypt : 欲加密的字串
     * @return 加密後的字串
     */
    public static String encrypt(String strToEncrypt) {
        String encryptString = "";
        try {
            int encryptKey[] = new int[strToEncrypt.length()];
            Random rand = new Random();
            for (int i = 0; i < strToEncrypt.length(); i++)
                encryptKey[i] = rand.nextInt(10);

            for (int s = 0; s < strToEncrypt.length(); s++) {
                char tmpChar = strToEncrypt.charAt(s);
                Character obChar = new Character(tmpChar);
                int tmpVal = obChar.charValue() ^ encryptKey[s];
//                System.out.print(new Integer(obChar.charValue()));
//                System.out.println("^" + encryptKey[s] + "=" + tmpVal);
                char newChar = (char) tmpVal;
//                System.out.println(newChar);
                encryptString += String.valueOf(newChar);
                if (s > encryptKey.length) {
                    s = 0;
                }
            }
            // 增加已加密註記 1
            encryptString += String.valueOf((char) (126 - encryptKey[0]));

            int iA[] = encryptKey;
            for (int i = 0; i < iA.length; i++) {
                encryptString += String.valueOf(String.valueOf((char) (iA[i] + 97)));
            }
			// 增加已加密註記 2
            encryptString += "~";
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return encryptString;
    }

    /**
     * 字串解密
     * 
     * @param strToDecrypt 欲解密的字串
     * @return 解密後的字串
     */
    public static String decrypt(String strToDecrypt) {
        String decryptString = "";
        try {
            if (isEncrypt(strToDecrypt)) {
                int key[] = new int[strToDecrypt.length() / 2];
                int iKeyIdx = 0;
                for (int a = strToDecrypt.length() / 2; a < strToDecrypt.length(); a++)
                    key[iKeyIdx++] = strToDecrypt.charAt(a) - 97;

                for (int d = 0; d < (strToDecrypt.length() / 2)-1; d++) {
                    char tmpChar = strToDecrypt.charAt(d);
                    Character obChar = new Character(tmpChar);
                    int tmpVal = obChar.charValue() ^ key[d];
                    char newChar = (char) tmpVal;
                    decryptString = String.valueOf(decryptString) + String.valueOf(newChar);
                }
            } else {
                decryptString = strToDecrypt;
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return decryptString;
    }

    /**
     * 字串加密
     * <p>
     * 使用此method加密的字串，必需使用decryptIgnoreCase解密
     * 
     * @param strToEncrypt : 欲加密的字串
     * @return 加密後的字串
     */
    public static String encryptIgnoreCase(String str) {
        return encrypt(str.toLowerCase());
        /*
        try {
            str = str.toLowerCase();
            int length = str.length();
            char array[] = new char[length];
            for (int i = 0; i < length; i++)
                array[i] = str.charAt(i);

            for (int count = 0; count < array.length; count++)
                switch (array[count]) {
                    case 97 : // 'a'
                        array[count] = '7';
                        break;

                    case 98 : // 'b'
                        array[count] = 'k';
                        break;

                    case 99 : // 'c'
                        array[count] = 'r';
                        break;

                    case 100 : // 'd'
                        array[count] = 's';
                        break;

                    case 101 : // 'e'
                        array[count] = '3';
                        break;

                    case 102 : // 'f'
                        array[count] = 'e';
                        break;

                    case 103 : // 'g'
                        array[count] = 'a';
                        break;

                    case 104 : // 'h'
                        array[count] = 'o';
                        break;

                    case 105 : // 'i'
                        array[count] = '8';
                        break;

                    case 106 : // 'j'
                        array[count] = ',';
                        break;

                    case 107 : // 'k'
                        array[count] = 'b';
                        break;

                    case 108 : // 'l'
                        array[count] = 'x';
                        break;

                    case 109 : // 'm'
                        array[count] = 'c';
                        break;

                    case 110 : // 'n'
                        array[count] = 'h';
                        break;

                    case 111 : // 'o'
                        array[count] = '5';
                        break;

                    case 112 : // 'p'
                        array[count] = '?';
                        break;

                    case 113 : // 'q'
                        array[count] = 'd';
                        break;

                    case 114 : // 'r'
                        array[count] = '4';
                        break;

                    case 115 : // 's'
                        array[count] = 'f';
                        break;

                    case 116 : // 't'
                        array[count] = 'm';
                        break;

                    case 117 : // 'u'
                        array[count] = 'z';
                        break;

                    case 118 : // 'v'
                        array[count] = 'g';
                        break;

                    case 119 : // 'w'
                        array[count] = '1';
                        break;

                    case 120 : // 'x'
                        array[count] = 'i';
                        break;

                    case 121 : // 'y'
                        array[count] = '9';
                        break;

                    case 122 : // 'z'
                        array[count] = 'j';
                        break;

                    case 49 : // '1'
                        array[count] = '6';
                        break;

                    case 50 : // '2'
                        array[count] = 'p';
                        break;

                    case 51 : // '3'
                        array[count] = '.';
                        break;

                    case 52 : // '4'
                        array[count] = '!';
                        break;

                    case 53 : // '5'
                        array[count] = '0';
                        break;

                    case 54 : // '6'
                        array[count] = 'l';
                        break;

                    case 55 : // '7'
                        array[count] = 'y';
                        break;

                    case 56 : // '8'
                        array[count] = 'n';
                        break;

                    case 57 : // '9'
                        array[count] = 'u';
                        break;

                    case 48 : // '0'
                        array[count] = 'q';
                        break;

                    case 46 : // '.'
                        array[count] = 'w';
                        break;

                    case 33 : // '!'
                        array[count] = 'v';
                        break;

                    case 63 : // '?'
                        array[count] = '2';
                        break;

                    case 44 : // ','
                        array[count] = 't';
                        break;

                    case 32 : // ' '
                        array[count] = ' ';
                        break;
                }

            encrypted = String.valueOf(array);
            StringBuffer reversed = new StringBuffer(encrypted);
            reversed.reverse();
            encrypted = new String(reversed);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        
        return encrypted;
        */
    }

    /**
     * 字串解密
     * 
     * @param str 欲解密的字串，該字串係經 encryptIgnoreCase 加密處理
     * @return 解密後的字串,並以lower case 的格式傳回
     */
    public static String decryptIgnoreCase(String str) {
    	return decrypt(str).toLowerCase() ;
    	/*
        String decrypted = "";
        try {
            str = str.toLowerCase();
            int length = str.length();
            char array[] = new char[length];
            StringBuffer reversed = new StringBuffer(str);
            reversed.reverse();
            String encrypted = new String(reversed);
            for (int i = 0; i < length; i++)
                array[i] = encrypted.charAt(i);

            for (int count = 0; count < length; count++)
                switch (array[count]) {
                    case 97 : // 'a'
                        array[count] = 'g';
                        break;

                    case 98 : // 'b'
                        array[count] = 'k';
                        break;

                    case 99 : // 'c'
                        array[count] = 'm';
                        break;

                    case 100 : // 'd'
                        array[count] = 'q';
                        break;

                    case 101 : // 'e'
                        array[count] = 'f';
                        break;

                    case 102 : // 'f'
                        array[count] = 's';
                        break;

                    case 103 : // 'g'
                        array[count] = 'v';
                        break;

                    case 104 : // 'h'
                        array[count] = 'n';
                        break;

                    case 105 : // 'i'
                        array[count] = 'x';
                        break;

                    case 106 : // 'j'
                        array[count] = 'z';
                        break;

                    case 107 : // 'k'
                        array[count] = 'b';
                        break;

                    case 108 : // 'l'
                        array[count] = '6';
                        break;

                    case 109 : // 'm'
                        array[count] = 't';
                        break;

                    case 110 : // 'n'
                        array[count] = '8';
                        break;

                    case 111 : // 'o'
                        array[count] = 'h';
                        break;

                    case 112 : // 'p'
                        array[count] = '2';
                        break;

                    case 113 : // 'q'
                        array[count] = '0';
                        break;

                    case 114 : // 'r'
                        array[count] = 'c';
                        break;

                    case 115 : // 's'
                        array[count] = 'd';
                        break;

                    case 116 : // 't'
                        array[count] = ',';
                        break;

                    case 117 : // 'u'
                        array[count] = '9';
                        break;

                    case 118 : // 'v'
                        array[count] = '!';
                        break;

                    case 119 : // 'w'
                        array[count] = '.';
                        break;

                    case 120 : // 'x'
                        array[count] = 'l';
                        break;

                    case 121 : // 'y'
                        array[count] = '7';
                        break;

                    case 122 : // 'z'
                        array[count] = 'u';
                        break;

                    case 49 : // '1'
                        array[count] = 'w';
                        break;

                    case 50 : // '2'
                        array[count] = '?';
                        break;

                    case 51 : // '3'
                        array[count] = 'e';
                        break;

                    case 52 : // '4'
                        array[count] = 'r';
                        break;

                    case 53 : // '5'
                        array[count] = 'o';
                        break;

                    case 54 : // '6'
                        array[count] = '1';
                        break;

                    case 55 : // '7'
                        array[count] = 'a';
                        break;

                    case 56 : // '8'
                        array[count] = 'i';
                        break;

                    case 57 : // '9'
                        array[count] = 'y';
                        break;

                    case 48 : // '0'
                        array[count] = '5';
                        break;

                    case 46 : // '.'
                        array[count] = '3';
                        break;

                    case 33 : // '!'
                        array[count] = '4';
                        break;

                    case 63 : // '?'
                        array[count] = 'p';
                        break;

                    case 44 : // ','
                        array[count] = 'j';
                        break;

                    case 32 : // ' '
                        array[count] = ' ';
                        break;
                }

            decrypted = new String(String.valueOf(array));
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return decrypted;
        */
    }

    public static boolean isEncrypt(String testString) {
        boolean returnStatus = false;
        if (testString.endsWith("~")) {
            if (testString.length() % 2 == 0) {
                int len = testString.length();
                String head = testString.substring(0, len / 2);
                String tail = testString.substring(len / 2, len);
                //System.out.println("head="+head.charAt(len / 2 - 1) );
                //System.out.println("tail="+(char)(126 - tail.charAt(0))) ;
				//System.out.println("tail="+(105-tail.charAt(0))) ;
                if (head.charAt(len / 2 - 1) == 126 - (tail.charAt(0) - 97)) {
                    returnStatus = true;
                }
            }
        }
        return returnStatus;
    }

    /**
     * 測試功能是否正常.
     * <p>
     * 執行後會在 System.out產生如下的輸出:<br>
     * message=test string<br>
     * enc=r`z}%zvunldgfjjfjchhcd<br>
     * dec=test string<br>
     * 
     * @param args
     * @throws Exception
     */
    public static void main(String args[]) throws Exception {
        String message = "cashweb";
        if(args.length>0 && args[0]!=null){
        	message = args[0];
        }
        String enc = encryptIgnoreCase(message);
        String dec = decrypt(enc);
        String dec1 = decrypt("testing1~");

        System.out.println("message=" + message);
        System.out.println("enc=" + enc);
        System.out.println("dec=" + dec);
        System.out.println("dec1=" + dec1);

    }
}